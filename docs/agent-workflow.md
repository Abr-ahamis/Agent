# Agent workflow

## Instruction layers
`AGENTS.md` gives repository-level guidance. `.agents/skills/reliable-work/SKILL.md` provides a reusable procedure for suitable work; it does not replace repository or task instructions. Task requirements define the requested outcome and boundaries, subject to platform rules and permissions.

Markdown conventions take effect only when the agent runtime discovers them or the agent is explicitly instructed to read them. A skill's presence or name alone does not guarantee activation.

## Normal workflow
1. Identify deliverables, scope, constraints, risk, and complexity.
2. Inspect relevant workspace, data, and environment; preserve existing changes.
3. Separate verified facts, assumptions, unknowns, and external claims.
4. Set observable acceptance criteria and choose domain-appropriate methods.
5. Plan proportionately; use task records for complex work, not trivial requests.
6. Execute manageable steps with minimal, recoverable changes.
7. Verify actual results against criteria; plans are not evidence.
8. Correct failures and recheck affected results. Report work, evidence, limits, and unresolved issues.

## Skills, tools, plans, and evidence
Skills describe reusable procedures; executable tools perform operations within permissions. A plan is not proof. Each check establishes only its stated scope. Final claims should map to observed evidence and identify incomplete work.

## Security assessment documentation

The security-work reference material is indexed in `docs/security-work/README.md`, with the 100-tool catalog under `docs/security-work/tool-catalog/`. These documents are not an activated skill. The expected `.agents/skills/security-work/SKILL.md` integration path is read-only in this workspace; when write access is available, add a concise routing skill that links to these references rather than duplicating them. Use the scope gate before any active security testing and retain engagement-specific observations in task evidence, not the reusable catalog.
