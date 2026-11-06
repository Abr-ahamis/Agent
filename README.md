# Cybersecurity Agent Workspace

This repository contains reusable security assessment references, a 100-entry tool catalog, a metadata-driven skill corpus, and framework-neutral Python routing/policy components. It does **not** contain a complete autonomous agent runtime or execute scans itself.

## Start here

- [Security skill architecture, selection, and authoring](docs/security-work/skills/README.md)
- [Skill corpus index](docs/security-work/README.md)
- [Tool registry](docs/security-work/tools.json)
- [Composable workflows](docs/security-work/workflows/README.md)
- [Existing detailed references and 100-tool catalog](docs/security-work/)

Example router use:

```python
from pathlib import Path
from cybersecurity import SkillRouter

router = SkillRouter(Path("docs/security-work/skills"))
plan = router.plan("I have an ELF executable from a CTF", environment="isolated challenge")
```

The router classifies from skill triggers, explains its matches, loads specialist content, and identifies prerequisites/tool candidates. Host integrations must supply observed tool availability, apply authorization checks to each active action, and connect results back to the router. A selection or plan never grants authorization.

## Local validation

```sh
python3 -m cybersecurity.validate
python3 -m unittest discover -s tests -v
bash scripts/validate-tool-catalog.sh
```

These checks are local structural/unit checks and do not contact or scan targets. See [agent workflow](docs/agent-workflow.md) and the security [scope gate](docs/security-work/references/scope-and-authorization.md).
