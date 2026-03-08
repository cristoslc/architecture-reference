"""
Tool functions for LLM-driven repository classification.

Gives the model native tool-calling access to a cloned repository.
Used with: llm --functions pipeline/tools/repo_tools.py

The REPO_ROOT environment variable must be set to the repo clone path.
"""

import os
import subprocess
import glob as glob_mod

REPO_ROOT = os.environ.get("REPO_ROOT", ".")
MAX_OUTPUT = 8000  # chars


def _resolve(path: str) -> str:
    """Resolve a path relative to REPO_ROOT, preventing escapes."""
    resolved = os.path.normpath(os.path.join(REPO_ROOT, path))
    if not resolved.startswith(os.path.normpath(REPO_ROOT)):
        return ""
    return resolved


def read_file(path: str, max_lines: int = 200) -> str:
    """Read a file from the repository. Path is relative to repo root.
    Returns up to max_lines lines (default 200). For large files, specify a smaller max_lines."""
    resolved = _resolve(path)
    if not resolved or not os.path.isfile(resolved):
        return f"Error: file not found: {path}"
    try:
        with open(resolved, "r", errors="replace") as f:
            lines = []
            for i, line in enumerate(f, 1):
                if i > max_lines:
                    lines.append(f"... truncated at {max_lines} lines ({i-1} total) ...")
                    break
                lines.append(f"{i:4d} | {line.rstrip()}")
        result = "\n".join(lines)
        return result[:MAX_OUTPUT]
    except Exception as e:
        return f"Error reading {path}: {e}"


def directory_tree(path: str = ".", depth: int = 3) -> str:
    """Show directory tree structure. Path is relative to repo root.
    Returns directories and files up to the specified depth."""
    resolved = _resolve(path)
    if not resolved or not os.path.isdir(resolved):
        return f"Error: directory not found: {path}"
    lines = []
    prefix_len = len(resolved)

    for root, dirs, files in os.walk(resolved):
        rel = root[prefix_len:].lstrip("/")
        level = rel.count("/") + (1 if rel else 0)
        if level > depth:
            dirs.clear()
            continue
        indent = "  " * level
        dirname = os.path.basename(root) or path
        lines.append(f"{indent}{dirname}/")
        # Skip hidden dirs and common noise
        dirs[:] = sorted([d for d in dirs if not d.startswith(".") and d not in (
            "node_modules", "__pycache__", ".git", "vendor", "dist", "build",
            ".next", ".nuxt", "target", "venv", ".venv"
        )])
        for f in sorted(files)[:30]:  # cap files per dir
            lines.append(f"{indent}  {f}")
        if len(files) > 30:
            lines.append(f"{indent}  ... and {len(files) - 30} more files")

    result = "\n".join(lines)
    return result[:MAX_OUTPUT]


def find_files(pattern: str) -> str:
    """Find files matching a glob pattern (e.g. '**/*.proto', 'src/**/*.java').
    Pattern is relative to repo root. Returns matching file paths."""
    full_pattern = os.path.join(REPO_ROOT, pattern)
    matches = sorted(glob_mod.glob(full_pattern, recursive=True))
    # Make paths relative
    results = []
    for m in matches[:100]:
        rel = os.path.relpath(m, REPO_ROOT)
        results.append(rel)
    if len(matches) > 100:
        results.append(f"... and {len(matches) - 100} more matches")
    return "\n".join(results) if results else f"No files matching: {pattern}"


def search_content(pattern: str, path: str = ".", file_glob: str = "") -> str:
    """Search file contents using grep. Pattern is a regex.
    Path is relative to repo root. Optional file_glob filters files (e.g. '*.java').
    Returns matching lines with file paths and line numbers."""
    resolved = _resolve(path)
    if not resolved:
        return f"Error: invalid path: {path}"
    cmd = ["grep", "-rn", "--include", file_glob if file_glob else "*",
           "-E", pattern, resolved]
    if not file_glob:
        cmd = ["grep", "-rn", "-E", pattern, resolved]
    try:
        result = subprocess.run(
            cmd, capture_output=True, text=True, timeout=10,
            cwd=REPO_ROOT
        )
        lines = result.stdout.strip().split("\n")
        # Make paths relative
        output_lines = []
        for line in lines[:50]:
            line = line.replace(resolved, path.rstrip("/"))
            output_lines.append(line)
        if len(lines) > 50:
            output_lines.append(f"... and {len(lines) - 50} more matches")
        out = "\n".join(output_lines)
        return out[:MAX_OUTPUT] if out else f"No matches for: {pattern}"
    except subprocess.TimeoutExpired:
        return "Error: search timed out"
    except Exception as e:
        return f"Error: {e}"


def shell_command(command: str) -> str:
    """Run a shell command in the repository root. Use for: ls, wc, head, find, etc.
    Commands are sandboxed to the repo directory. Timeout: 10 seconds."""
    try:
        result = subprocess.run(
            command, shell=True, capture_output=True, text=True,
            timeout=10, cwd=REPO_ROOT
        )
        output = result.stdout + result.stderr
        return output[:MAX_OUTPUT] if output else "(no output)"
    except subprocess.TimeoutExpired:
        return "Error: command timed out (10s limit)"
    except Exception as e:
        return f"Error: {e}"
