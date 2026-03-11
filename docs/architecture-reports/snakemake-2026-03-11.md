# snakemake — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/snakemake/snakemake
**Classification:** Pipeline + Microkernel
**Confidence:** 0.93

## Summary

Snakemake is a Python-based scientific workflow management system whose primary architectural expression is the Pipeline (DAG-based pipe-and-filter) pattern: users declare rules that transform input files into output files, the engine resolves a Directed Acyclic Graph of jobs, and execution proceeds by topologically ordering and running those pipeline stages. The secondary style is Microkernel: six formally typed plugin interfaces (executor, storage, report, logger, scheduler, and a common base) define stable extension points that allow third-party code to add execution backends, cloud storage providers, report formats, logging sinks, and scheduling algorithms without modifying the core engine. All components live in a single Python package (`snakemake`) distributed as one PyPI wheel — a modular monolith in deployment topology, not independent services.

## Evidence

### Directory Structure

```
src/snakemake/
  cli.py                  # CLI entry point (argparse, ~2285 lines)
  api.py                  # SnakemakeApi / WorkflowApi / DAGApi (~831 lines)
  workflow.py             # Workflow class — central orchestrator (~2497 lines)
  dag.py                  # DAG class — job dependency graph (~3416 lines)
  jobs.py                 # Job / GroupJob / JobFactory (~1986 lines)
  rules.py                # Rule class — pipeline step definition (~1479 lines)
  parser.py               # DSL parser (Mealy machine hierarchy) (~1414 lines)
  scheduling/
    job_scheduler.py      # JobScheduler — async execution loop
    greedy.py             # Built-in greedy knapsack scheduler
    milp.py               # ILP-based scheduler (optional)
  executors/
    local.py              # Built-in local executor (ThreadPoolExecutor)
    dryrun.py             # Dry-run executor
    touch.py              # Touch executor
  deployment/
    conda.py              # Conda environment management
    singularity.py        # Singularity/Apptainer container support
    env_modules.py        # HPC environment modules support
  caching/                # Output file cache (local and storage-backed)
  persistence.py          # Job metadata / provenance persistence
  sourcecache.py          # Remote source file caching
  linting/                # DSL static analysis
  report/                 # HTML report generation
  settings/               # Typed dataclass settings hierarchy
  io/                     # IOFile, wildcards, flags
  script/                 # R, Julia, Rust, Python script integration
  modules.py              # Workflow module system (reusable sub-workflows)
```

### Key Architectural Files

- `src/snakemake/dag.py`: `DAG` class implements `DAGExecutorInterface`, `DAGReportInterface`, `DAGSchedulerInterface`. Methods `init()`, `update_needrun()`, `toposort()` resolve the job dependency graph; `retrieve_storage_inputs()`, `store_storage_outputs()` transfer files through the pipeline.
- `src/snakemake/workflow.py`: `Workflow` implements `WorkflowExecutorInterface`. Hosts rule definitions, instantiates the DAG, drives the scheduler, and exposes `execute()`.
- `src/snakemake/scheduling/job_scheduler.py`: `JobScheduler` implements `JobSchedulerExecutorInterface`. Central async event loop that repeatedly evaluates ready jobs, dispatches them to executor plugins, and post-processes completions.
- `src/snakemake/api.py`: Three-tier API (`SnakemakeApi -> WorkflowApi -> DAGApi`) that mediates between CLI/programmatic callers and the core engine via plugin registries.
- `src/snakemake/executors/local.py`: Built-in executor extending `RealExecutor` from `snakemake-interface-executor-plugins`; demonstrates the plugin contract.
- `pyproject.toml` dependencies: `snakemake-interface-executor-plugins`, `snakemake-interface-storage-plugins`, `snakemake-interface-report-plugins`, `snakemake-interface-logger-plugins`, `snakemake-interface-scheduler-plugins`, `snakemake-interface-common` — six independently versioned interface packages.

### Patterns Found

**Pipeline (primary — DAG-based pipe-and-filter):**
- Every workflow is expressed as `Rule` objects that declare input files, output files, and a transformation (shell command, Python/R/Julia script, wrapper, notebook).
- The `DAG` class resolves a topological ordering of jobs (`toposort()`, `graphlib.TopologicalSorter`) and marks only jobs that need to run (`update_needrun()`).
- The `JobScheduler` dispatches ready jobs respecting resource constraints — the classic pipe-and-filter execution model where each stage (job) consumes upstream outputs and produces downstream inputs.
- `from_queue` I/O flag enables streaming/queue-based data flow between rules, reinforcing the pipeline model.
- Scatter/Gather primitives (`Scatter`, `Gather` in `workflow.py`) express fan-out/fan-in pipeline patterns.

**Microkernel (secondary — formal typed plugin system):**
- Six independently semver'd interface packages define abstract base classes for each extension dimension.
- `ExecutorPluginRegistry`, `StoragePluginRegistry`, `ReportPluginRegistry`, `SchedulerPluginRegistry` — runtime plugin discovery and registration in `api.py` and `scheduling/job_scheduler.py`.
- Plugin naming convention (`snakemake-<type>-plugin-<name>`) and PyPI-based auto-discovery enable a catalog of third-party plugins (cluster-generic, SLURM, Kubernetes, S3, GCS, etc.) without core modification.
- Interface packages provide abstract base classes (`RealExecutor`, `StorageProviderBase`, `SchedulerBase`, `LogHandlerBase`) that plugins must implement — a rigorous contract pattern.
- Official documentation (`docs/project_info/codebase.rst`) explicitly names this the architecture: "a combination of a main package, a set of plugin interface packages… and plugin packages implementing those interfaces."

**Layered (internal organization):**
- The codebase's own documentation identifies three internal levels: user-facing level (CLI + API), language level (parser/DSL), and core level (Workflow, DAG, Scheduler, Persistence).
- These form a strict dependency hierarchy: CLI depends on API; API depends on Workflow; Workflow depends on DAG and Scheduler; DAG depends on Rules and Jobs.
- This layering is real and significant but subordinate to the pipeline and microkernel organizing principles.

**Modular Monolith (deployment topology):**
- Single `pyproject.toml` wheel (`snakemake`), single Python package (`src/snakemake/`), single process for local execution. There are no independently deployed services.
- Remote cluster execution spawns sub-processes via executor plugins but the control plane remains a single Python process.

## Architecture Styles Identified

### Pipeline (Primary)

The defining user-facing and internal organizing principle is the DAG-based pipeline. A Snakemake workflow is a data-processing pipeline: rules are stages, files are the data flowing between stages, and the entire engine exists to resolve, order, and execute those stages correctly. The `DAG` class is the structural heart of the system — it topologically sorts jobs, identifies what needs to run (based on file timestamps and provenance hashes), and manages data transfer to/from storage backends. The `JobScheduler` then drives execution by iterating the DAG-ready frontier, dispatching jobs, and collecting completions. This is textbook pipe-and-filter: transformation stages connected by named data channels (file paths / wildcards).

### Microkernel (Secondary)

Snakemake's plugin architecture is formal, deliberate, and explicitly designed. Six interface packages define extension points with typed abstract base classes. Plugins are discovered from the Python environment at runtime via `ExecutorPluginRegistry`, `StoragePluginRegistry`, and so on. The core engine invokes plugins through the interface contracts without knowing about specific implementations. This is the defining property of the microkernel style: a stable core with formal extension mechanisms allowing third-party code to add capabilities. The official architecture description in `codebase.rst` confirms this as the intentional design.

### Layered (Internal structure)

The three-tier internal structure (user-facing, language, core) provides the internal organization of the core package. It is a real and deliberate layering but is a supporting structural concern subordinate to the pipeline and microkernel styles.

## Quality Attributes

- **Reproducibility:** Provenance hash tracking (`caching/hash.py`, `Persistence`), conda/singularity environment pinning, and output file caching ensure bitwise-identical results across runs and environments.
- **Scalability:** Plugin-based execution backends (SLURM, Kubernetes, cloud, cluster-generic) allow workflows to scale from laptops to HPC clusters and cloud without workflow modification; resource-constrained scheduling (greedy + ILP) maximizes parallelism within limits.
- **Extensibility:** Six formal plugin extension points (executor, storage, report, logger, scheduler, common) with auto-discovery allow adding new backends, storage systems, and report formats without modifying the core.
- **Portability:** Workflows run unchanged across local, HPC, grid, and cloud environments; storage plugins abstract S3, GCS, Azure, XRootD, HTTP; conda/singularity deployment makes software environments portable.
- **Maintainability:** Clear internal layering (user-facing, language, core), strong separation via interface packages, independent semantic versioning of interface packages reduces cross-cutting change impact.
- **Interoperability:** CWL export (`cwl.py`), Jupyter notebook integration (`notebook.py`), scripting in R/Julia/Rust/Python (`script/`), wrapper ecosystem connecting to Bioconda tools.
- **Observability:** Pluggable logger system with log event types (`LogEvent`), timestamped run logs in `.snakemake/log/`, benchmark output per rule, DAG visualization export.
- **Reliability:** Atomic output file handling, incomplete output detection, checkpoint mechanism for dynamic DAG re-evaluation, provenance-based rerun detection.

## Classification Reasoning

The decisive question is: what is the primary organizing principle? For Snakemake, it is unambiguously the pipeline metaphor — rules are stages, files are the data flowing through the pipeline, and the entire engine (parser, DAG, scheduler, executor plugins) exists to resolve and drive that pipeline. This is confirmed at every level: the user-facing DSL, the central `DAG` class, the `JobScheduler`, and the official documentation description.

The Microkernel label is fully merited as a strong secondary style. Six independently versioned interface packages with abstract base classes, runtime plugin registries, a formal naming convention, PyPI-based auto-discovery, and an official plugin catalog constitute a deliberate and mature microkernel extension system — not ad-hoc escape hatches.

Confidence is 0.93 (very high). The Pipeline classification is supported by both the user-facing DSL design and the internal execution architecture. The Microkernel secondary is explicitly designed and documented. The minor confidence gap reflects the fact that the layered internal structure and the async asyncio-based concurrency model are also notable, but neither rises to the level of a primary architectural style.
