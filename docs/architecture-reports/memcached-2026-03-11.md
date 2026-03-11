---
project: "Memcached"
date: 2026-03-11
scope: application
use-type: production
primary-language: C
confidence: 0.95
styles:
  - name: Layered
    role: primary
    confidence: 0.93
  - name: Event-Driven
    role: primary
    confidence: 0.88
---

# Architecture Analysis: Memcached

## Metadata

| Field | Value |
|---|---|
| Project | Memcached |
| Repo | https://github.com/memcached/memcached |
| Date | 2026-03-11 |
| Scope | application |
| Use-type | production |
| Primary Language | C |
| Other Languages | Lua (proxy scripting) |

## Style Rationales

**Layered (primary, 0.93):** Memcached organises its internals into clearly delineated horizontal layers with strict downward dependencies. The outermost layer is the network and protocol layer: `proto_text.c`, `proto_bin.c`, and `proto_parser.c` parse ASCII and binary protocol commands and build response objects (`mc_resp`), and `proto_proxy.c`/`proxy_network.c` handle the optional Lua-driven proxy protocol. Below that sits the threading and I/O dispatch layer: `thread.c` manages the dispatcher thread and N libevent worker threads, each owning an `event_base`; `conn` state-machine transitions in `memcached.c`'s `drive_machine()` handle reading, parsing, writing, and closing without blocking. Below that is the item and LRU management layer: `items.c` owns HOT/WARM/COLD/TEMP segmented LRU lists with per-LRU locks, reference counting, and TTL logic; `crawler.c` provides a background LRU-crawl thread; `assoc.c` manages the lock-striped hash table. At the base is the memory allocation layer: `slabs.c` implements the slab allocator (fixed-class memory pools), `slabs_mover.c` drives background page reassignment, and `slab_automove.c` adaptively rebalances classes. The optional `extstore.c`/`storage.c` layer provides an async flash/disk tier below RAM. Each layer communicates only with its immediate neighbour through well-defined C function interfaces; cross-layer pointers are not present.

**Event-Driven (primary, 0.88):** The entire request-handling path is structured around non-blocking I/O events dispatched by libevent. The main thread runs one `event_base` for listener sockets; each worker thread runs its own `event_base` with an `EV_READ|EV_PERSIST` event per client connection. The `event_handler()` callback (registered via `event_add()`) is the sole entry point for new I/O readiness, invoking `drive_machine()` which implements a 16-state FSM (`conn_states`) rather than blocking call stacks. Background subsystems communicate back to worker threads through lightweight notification channels: a pipe or `eventfd` per thread (`thread_notify`) wakes a worker when async work (extstore IO, proxy response) completes. The `io_queue_t` mechanism stacks pending async IO descriptors and fires `submit_cb`/`return_cb` callbacks when the extstore IO threads or proxy threads finish. The logger subsystem uses a lock-free bipbuffer per thread with a separate watcher thread for non-blocking log emission. Every long-latency operation (flash reads, proxy upstream connections) is offloaded from the event loop via callback, ensuring the event threads never block.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| Separate protocol-parse files wrapping a storage core | `proto_text.c`, `proto_bin.c`, `proto_parser.c` | Layered |
| Network/protocol layer produces `mc_resp` objects consumed by transmit layer | `memcached.h:771-806` | Layered |
| Worker thread dispatch layer in dedicated module | `thread.c` | Layered |
| `items.c` HOT/WARM/COLD/TEMP LRU layer above slab allocator | `items.c`, `items.h` | Layered |
| Slab allocator isolated at lowest layer with own lock | `slabs.c`, `slabs.h` | Layered |
| `extstore.c` optional flash tier below RAM tier | `extstore.c`, `extstore.h`, `storage.c` | Layered |
| Hash table (`assoc.c`) accessed only through item lock layer | `assoc.c`, `assoc.h` | Layered |
| Lock ordering documented: `item_lock -> lru_lock -> slabs_lock` | `doc/threads.txt:38-40` | Layered |
| One `event_base` per worker thread; all I/O non-blocking | `thread.c:92`, `memcached.c:120` | Event-Driven |
| `event_handler()` sole I/O entry point dispatching state machine | `memcached.c:96,2961` | Event-Driven |
| 16-state connection FSM (`conn_states`) driven by libevent events | `memcached.h:202-218`, `memcached.c:944` | Event-Driven |
| Per-thread pipe/eventfd wakeup for async result notification | `memcached.h:710-718` | Event-Driven |
| `io_queue_t` submit/return callbacks for extstore and proxy async work | `memcached.h:703-708` | Event-Driven |
| Bipbuffer-based non-blocking logger per worker thread | `logger.c`, `bipbuffer.c` | Event-Driven |
| `conn_resp_suspend`/`conn_resp_unsuspend` macros gate transmit on async completion | `memcached.h:948-961` | Event-Driven |
| Proxy Lua VM per worker thread; upstream responses drive callbacks | `proxy_network.c`, `proxy_lua.c` | Event-Driven |

## What Was Rejected and Why

**Not Microservices / Service-Based:** Memcached is a single OS process (or multiple independent identical processes for horizontal scale). All subsystems — protocol parsing, thread management, slab allocation, item management, logging — compile and link into one binary. There are no service boundaries, no inter-service protocols, and no independent deployable units.

**Not Microkernel:** While the proxy extension can be enabled at compile time and uses Lua scripting for routing, there is no plugin registration mechanism, no binary plugin loader, and no stable extension API. Compile-time `#ifdef PROXY` / `#ifdef EXTSTORE` guards are feature flags, not a kernel/plugin contract.

**Not Pipeline:** Although there is a sequence (receive bytes -> parse -> execute -> respond), this is a synchronous per-request call sequence within a single event callback, not a staged dataflow architecture with distinct pipeline components processing streams.

**Not CQRS:** All reads and writes go through the same item/slab subsystem with the same thread model. There is no separate read model or write model.

## Quality Attributes Evidence

**Performance:** Non-blocking I/O via libevent, per-thread event loops, slab allocator eliminating heap fragmentation, lock-striped hash table for parallel item access, lock-free per-thread LRU bump buffers, and async extstore reads — all oriented toward maximum throughput at minimum latency.

**Scalability:** Linear horizontal scaling via independent processes (no shared state between instances), configurable worker thread count (`-t`), NAPI ID CPU pinning for NUMA locality, UDP support for stateless fan-out queries.

**Reliability:** Reference-counted items prevent use-after-free; slab allocator avoids general-purpose heap; warm restart (`restart.c`) serialises memory to disk for safe daemon restarts without cache flush; SASL and TLS for authenticated encrypted connections.

**Evolvability:** Protocol-specific logic isolated in `proto_*.c` files; extstore and proxy are compile-time optional subsystems; `io_queue_t` abstraction decouples async backends from worker threads; Lua scripting in the proxy layer allows routing logic changes without recompilation.

**Observability:** Rich `stats` command exposing per-thread, per-slab, and global counters; structured logger with per-event type handlers and watcher-based streaming; DTrace probes (`memcached_dtrace.d`); `stats_prefix` for key-prefix-level statistics.
