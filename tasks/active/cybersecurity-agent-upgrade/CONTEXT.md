# Context

## Environment and tools
Repository contains Markdown references/catalog, Bash bootstrap/validation scripts, and a Markdown scenario list. No application source, dependency manifest, root README, or runtime entry point is tracked. `.agents/` is read-only by environment permission.

## Sources of truth
`AGENTS.md`, `docs/agent-workflow.md`, `docs/security-work/README.md`, `docs/security-work/references/`, `docs/security-work/tool-catalog/`, existing validators, and `tests/skill-evaluation-cases.md`.

## Established facts
- The security reference set includes scope authorization, engagement workflows, network, web, Linux, Windows, AD, reporting, and tool usage.
- The catalog validator is structural and does not execute security tools.
- The docs currently say the security materials are not an activated runtime skill.

## Assumptions
- A small standard-library Python package is an appropriate framework-neutral addition because no runtime exists.

## Unknowns
- Whether a future agent host will discover this package automatically; document the integration adapter requirement.
