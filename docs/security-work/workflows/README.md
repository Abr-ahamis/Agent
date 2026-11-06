# Reusable investigation workflow

Use phases as a checklist, not a rigid script. A CTF can start with an artifact; a bounty starts with program rules; AD review starts with identity/domain context. Record skipped phases and why.

1. **Understand:** objective, artifact/target type, engagement, expected result.
2. **Prepare:** authorization/scope, exclusions, stop conditions, prerequisites, environment and installed-tool checks.
3. **Discover:** minimally identify assets, components, files, protocols, routes, or technologies.
4. **Enumerate:** deepen only relevant surfaces; preserve uncertainty and tool limits.
5. **Analyze:** state hypotheses and competing explanations; link evidence to a security boundary.
6. **Test:** choose the least intrusive discriminating test; bound rate/state and retain alternatives.
7. **Verify:** reproduce, corroborate, assess impact, reject false positives, stop at minimum proof.
8. **Document:** evidence, successful/failed paths, limits, remediation, next owner-approved action.

## Routing examples

- “I have an ELF from a CTF”: `binary-analysis`; add `crypto-forensics` only if evidence indicates embedded/encoded artifacts. Start with local format/header/string inspection. Run unknown code only in an isolated challenge VM.
- “Assess this Windows domain”: `active-directory`, optionally `network-assessment` for approved discovery and `windows-assessment` for authorized local review. Gather scope, identity and collection permissions first.
- “Review an in-scope bounty API”: `bug-bounty-web-api`; compose `finding-validation` for a candidate issue. Read current program scope before active requests.
- “Nmap says filtered”: `network-assessment`; check vantage/routing and interpret uncertainty before another bounded probe. Do not increase rate automatically.

## Stop and branch rules

Stop active work on unclear scope, unexpected sensitive data, instability, out-of-scope redirection, or exceeded limits. Negative findings justify a new hypothesis only when evidence supports it. Missing tools lead to documented alternatives; missing permission leaves dependent actions unrun. Newly discovered assets require separate scope confirmation.
