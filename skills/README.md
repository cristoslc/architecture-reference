# Published Skills

Agent skills published by this repository, installable into other projects via [remote-skill-manager](#remote-skill-manager).

## Available skills

| Skill | Description |
|-------|-------------|
| [architecture-advisor](architecture-advisor/) | Evidence-based architecture research from 276 real-world projects |
| [remote-skill-manager](remote-skill-manager/) | Fetch, track, and update skills from remote Git repositories |

## Quick start

### 1. Bootstrap remote-skill-manager

The first skill you install must be done manually — after that, it manages itself.

```bash
# One-time bootstrap: clone and copy remote-skill-manager into your project
git clone --depth 1 https://github.com/cristoslc/architecture-reference-repo /tmp/arch-ref
cp -R /tmp/arch-ref/skills/remote-skill-manager .agents/skills/remote-skill-manager
rm -rf /tmp/arch-ref
```

### 2. Install architecture-advisor

```bash
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/architecture-advisor \
  main \
  .agents/skills
```

This installs the skill's `SKILL.md` and `scripts/`. Reference data is fetched on first use (the agent runs `bash scripts/sync-references.sh` automatically).

### 3. Update skills

Re-run the same fetch command to pull the latest version. The script is idempotent — it overwrites files and re-stamps `.source.yml` with the new commit and integrity hash.

To update remote-skill-manager itself:

```bash
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/remote-skill-manager \
  main \
  .agents/skills
```

## Verifying installs

Each skill includes a smoke test:

```bash
bash .agents/skills/remote-skill-manager/scripts/smoke-test.sh
bash .agents/skills/architecture-advisor/scripts/smoke-test.sh
```

## Drift detection

Fetched skills include a `.source.yml` provenance manifest with an integrity hash. If you modify a fetched skill locally, the hash will no longer match — this is called "drift." See the [remote-skill-manager SKILL.md](remote-skill-manager/SKILL.md) for drift detection commands.
