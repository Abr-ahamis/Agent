# Security assessment reporting

Write findings for reproducibility and remediation while minimizing sensitive data. Separate scope, test coverage, and conclusions.

## Assessment summary

State engagement type and authorization basis, included targets, exclusions, testing window, tools/versions where material, and constraints. Summarize what was actually tested, services/apps found, unavailable or untested areas, and coverage limits. Never imply full coverage without evidence.

## Finding record

For each item include ID/title, affected asset/endpoint/service, discovery source and date, observation, minimal safe reproduction, preconditions, verification status (`CONFIRMED`, `LIKELY`, `UNVERIFIED`, `FALSE_POSITIVE`, `NOT_APPLICABLE`, `NOT_TESTED`), practical impact and severity rationale, confidence/limitations, relevant advisory/CVE sources, remediation, and retest procedure. Redact tokens, credentials, personal data, and unrelated content.

Use `CONFIRMED` only where evidence establishes the issue and stated impact. Report banner/version matches as candidate exposure until applicability and prerequisites are validated. Distinguish exploit attempted, failed, reproduced, execution obtained, and privilege level demonstrated.

## Format by engagement

- **CTF:** verified walkthrough and challenge completion evidence; keep challenge secrets/artifacts confined to the environment.
- **Bug bounty:** concise, reproducible minimum-impact report matching program rules, with only necessary redacted requests/responses.
- **Pentest:** executive summary plus detailed technical findings, coverage/method, limitations, remediation priorities, and retest plan.

Never invent services, versions, CVEs, impact, successful access, flags, tests, or evidence. An unrun check is unverified; list unresolved work plainly.
