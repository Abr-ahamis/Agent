# Engagement-specific workflows

All workflows use the [scope and authorization gate](scope-and-authorization.md), service/application enumeration, and evidence/reporting rules. None grants authorization.

## CTF or isolated lab

Confirm challenge target isolation and objective. Preserve supplied artifacts, inspect locally first, form a hypothesis from observed outputs, and use lab-only exploitation when needed. Explain mechanism and reproduce the intended result. Keep flags, credentials, and artifacts inside the challenge. Report exact completion evidence and untested branches.

## Bug bounty

Read the live program's in-scope assets, exclusions, rate limits, safe-harbor terms, and prohibited techniques before active requests. Use passive information and minimum-rate checks. Do not follow third-party links into tests. Avoid account lockout, destructive changes, data access beyond minimum proof, and exploit chains the program prohibits. Report concise reproducible evidence and stop after impact is demonstrated.

## Formal penetration test

Confirm signed scope, test windows, accounts, methods, escalation/pivot approvals, emergency contacts, and stop conditions. Coordinate high-volume or stateful tests. Keep a coverage matrix and evidence log, independently validate high-risk findings, track cleanup/state changes, and produce executive plus technical reports with limitations and retest criteria.
