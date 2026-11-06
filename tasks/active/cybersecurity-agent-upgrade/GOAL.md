# Goal

## Desired state
Add a maintainable, machine-discoverable cybersecurity skill system with automatic skill composition, documented tool choice, reusable workflows, safety checks, tests, and user documentation.

## Scope and boundaries
Work within this repository. Preserve the existing security references and tool catalog. `.agents/` is read-only in this environment, so new runtime-facing components will live under writable `cybersecurity/` and `docs/security-work/` paths. No live targets, tools, or dependencies will be installed or invoked.
