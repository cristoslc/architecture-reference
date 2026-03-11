# nats-server — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/nats-io/nats-server
**Classification:** Event-Driven + Modular Monolith
**Confidence:** 0.93

## Summary

NATS Server is a high-performance messaging broker whose primary architectural expression is Event-Driven: the entire system is organized around a publish-subscribe messaging backbone, subject-based routing, and asynchronous message delivery. The codebase is deployed as a single binary built from one Go module, with all subsystems (core pub-sub, JetStream persistence, clustering, gateways, leaf nodes, MQTT, WebSocket, monitoring) co-located in a single `server` package that communicates through internal message passing over subject channels rather than function calls — making Modular Monolith the secondary style. The Raft-based consensus layer (used exclusively by JetStream clustering) is an implementation mechanism for distributed consistency, not a separate service boundary.

## Evidence

### Directory Structure

```
main.go                    # thin entry point — wires Options, creates Server, calls Run()
server/
  server.go                # Server struct (~4800 lines) — main lifecycle, AcceptLoop
  client.go                # client connection I/O, readLoop/writeLoop, processMsgResults
  sublist.go               # subject-matching trie — the core routing engine
  events.go                # internal system account event bus ($SYS.* subjects)
  jetstream.go             # JetStream engine lifecycle and config
  jetstream_api.go         # JetStream management API (NATS subjects, not HTTP)
  jetstream_cluster.go     # distributed JetStream via Raft meta-group (~10,900 lines)
  stream.go                # Stream entity — retention, limits, replication
  consumer.go              # Consumer entity — ack policies, delivery
  filestore.go             # file-backed message store (~13,400 lines)
  memstore.go              # in-memory message store
  store.go                 # MsgStore / StreamStore interfaces
  raft.go                  # internal Raft consensus implementation (~5000 lines)
  route.go                 # server-to-server clustering (route protocol)
  gateway.go               # inter-cluster gateway links
  leafnode.go              # leaf node hub-and-spoke federation
  accounts.go              # Account / multi-tenancy / import-export (~4800 lines)
  auth.go                  # authentication — users, tokens, NKeys, JWT
  mqtt.go                  # MQTT protocol adapter (pub-sub semantics mapped to NATS)
  websocket.go             # WebSocket transport layer
  monitor.go               # HTTP monitoring endpoints (/varz, /connz, /routez, ...)
  parser.go                # NATS wire protocol parser (state machine)
  opts.go                  # configuration wiring
  sendq.go / ipqueue.go    # internal async message queues
logger/                    # structured logger
conf/                      # config file parser
internal/
  fastrand/                # fast PRNG
  ldap/                    # LDAP auth support
  ocsp/                    # OCSP stapling
  tpm/                     # TPM key support
server/ats/, avl/, gsl/,
  stree/, thw/, elastic/   # internal data structures (concurrent trie, AVL tree, etc.)
```

### Core Architectural Pattern: Event-Driven Pub-Sub

The entire runtime is organized around an asynchronous publish-subscribe message bus:

- **`sublist.go`** — a wildcard-capable subject trie (`Sublist`) is the routing core. Every `PUB` from a client is matched against all registered subscriptions; matched subscribers receive the message. Wildcards (`*`, `>`) are first-class.
- **`client.go`** — `readLoop` / `writeLoop` are per-connection goroutines. `processMsgResults` fans out a published message to all matched `*subscription` entries, handling queue groups, leaf-node forwarding, and gateway routing.
- **`events.go`** — the internal server event bus uses the same pub-sub mechanism over a system account (`$SYS.*` subjects). Connect/disconnect advisories, server stats, OCSP events, auth errors, lame-duck signals — all emitted as NATS messages to internal subscribers, not as function calls.
- **JetStream API** (`jetstream_api.go`) — the entire JetStream management surface (create/delete streams and consumers, publish, fetch, ack) is exposed as NATS subjects (e.g. `$JS.API.STREAM.CREATE.*`), not HTTP endpoints. Operators and clients interact via the same pub-sub bus.
- **Internal message passing** — `sendInternalMsg` / `systemSubscribe` implement a clean separation between subsystems: JetStream, accounts, clustering, and auth all communicate by publishing to and subscribing from `$SYS.*` or `$JS.*` subjects on the internal client, rather than calling each other's functions directly.

### Secondary Style: Modular Monolith

All subsystems live in a single Go package (`package server`) and binary. There are no separate processes for JetStream, auth, or monitoring. However, functional boundaries are cleanly maintained:

| Subsystem | Primary Files |
|---|---|
| Core Pub-Sub Router | `sublist.go`, `client.go`, `parser.go` |
| JetStream (Streams/Consumers) | `jetstream.go`, `jetstream_api.go`, `stream.go`, `consumer.go` |
| JetStream Clustering (Raft) | `jetstream_cluster.go`, `raft.go` |
| Storage | `filestore.go`, `memstore.go`, `store.go` |
| Clustering (Routes/Gateways/Leafs) | `route.go`, `gateway.go`, `leafnode.go` |
| Multi-Tenancy / Security | `accounts.go`, `auth.go`, `jwt.go`, `nkey.go` |
| Protocol Adapters | `mqtt.go`, `websocket.go`, `client_proxyproto.go` |
| Observability | `monitor.go`, `events.go`, `msgtrace.go` |

Subsystems interact primarily through the internal pub-sub bus and shared `Server` struct state protected by `sync.RWMutex`. This is a deliberate design choice for performance (shared memory, zero-copy message delivery) rather than a coupling deficiency.

### Raft / Clustering: Implementation Mechanism, Not Style

`raft.go` implements a full Raft consensus algorithm used only by JetStream's meta-group and stream replication groups. It is not a separate service or deployment unit — it runs inside the server process and exposes proposals and apply queues through the `RaftNode` interface. The Raft layer enables distributed JetStream but does not define the overall architecture of the server.

### Protocol Adapters

MQTT (`mqtt.go`) and WebSocket (`websocket.go`) are protocol translation layers that bridge foreign client protocols into NATS pub-sub semantics internally. They do not expose a separate service — messages published via MQTT or WS are routed through the same `Sublist` as native NATS messages.

### Key Data-Flow

```
Client TCP connection
  -> readLoop() (goroutine per connection)
  -> parse() state machine (parser.go)
  -> processPublish() / processMsg()
  -> Sublist.Match(subject) -> []subscription
  -> processMsgResults() -> deliverMsg() per matched subscriber
  -> writeLoop() -> TCP send
         |
         +-- if JetStream subject -> jetstream_api.go handler (via system subscribe)
         +-- if $SYS subject     -> events.go handler
         +-- if routed            -> route.go / gateway.go forwarding
```

### Quality Attributes Observed

- **Performance** — zero-allocation message dispatch paths, lockless atomic stats, per-connection goroutines with fixed-size ring buffers, HighwayHash for subject hashing.
- **Scalability** — horizontal via cluster routes and gateway links; vertical via account isolation and per-account sublists.
- **Reliability** — JetStream persistence (file and memory store) with Raft replication; at-least-once delivery via ack policies; consumer state survives server restart.
- **Security** — NKey ed25519 auth, JWT operator trust chains, OCSP stapling, TLS with certificate pinning, multi-tenant account isolation with import/export controls.
- **Extensibility** — auth callout mechanism (`auth_callout.go`) allows external auth services via the NATS request-reply pattern; leaf nodes enable federated topologies.
- **Observability** — HTTP monitoring endpoints (`/varz`, `/connz`, `/routez`, `/jsz`), structured server advisories published to `$SYS.*` subjects, distributed message tracing (`msgtrace.go`).

## Classification Reasoning

NATS Server's organizing principle is asynchronous, decoupled message exchange through a subject-based pub-sub engine — the definition of Event-Driven architecture. Every major feature, including JetStream persistence, clustering management, system advisories, and protocol adaptation, is layered on top of this pub-sub backbone and communicates through it rather than through direct call graphs. The system is also a Modular Monolith: a single deployable binary containing cleanly separated functional subsystems that share a process boundary for performance reasons. It is explicitly not Microservices (one binary, one process), not Pipeline (no directed data transformation graph), and not Layered (no strict layer discipline; subsystems reference each other across tiers through the message bus).
