---
{"name":"finding-validation","description":"Validate suspected security weaknesses against applicability, prerequisites, expected boundaries, reproducibility, and minimum safe impact before reporting.","domain":"validation","subdomains":["false positive reduction","CVE applicability","reporting","evidence"],"triggers":["validate finding","verify vulnerability","false positive","CVE validation","security finding report","exploit validation"],"excludes":["destructive proof of concept without approval"],"prerequisites":["Identify scope, evidence source, affected asset, applicable permissions, and stop conditions; do not access unrelated data."],"tools":["curl","vendor advisories","package metadata","Burp Suite","Nmap output review"],"references":["../../references/cve-research-and-validation.md","../../references/authorized-exploit-validation.md","../../references/security-reporting.md"]}
---
# Finding validation and reporting

## Methodology
1. State the claim precisely and separate direct observation, inference, and unknown. Identify expected secure behavior and affected boundary.
2. Check applicability: exact product/build/package, vendor backports, configuration, exposure, prerequisites, and compensating controls. A banner/CVE scanner result is a lead.
3. Choose the least intrusive discriminating test. Prefer configuration evidence, controlled accounts/fixtures, benign marker, or owner-side verification over exploitation.
4. Repeat with a clean request/session and corroborate through an independent source. Rule out proxy/cache, custom error, test setup, stale data, and expected behavior.
5. Stop once minimum impact is established. Assign `CONFIRMED`, `LIKELY`, `UNVERIFIED`, `FALSE_POSITIVE`, `NOT_APPLICABLE`, or `NOT_TESTED`; explain confidence and limits.

## Decision
- Applicability unknown: obtain authoritative vendor/package evidence; leave unverified if unavailable.
- Reproduction fails: check prerequisites, identity, version and environment; do not reinterpret failed test as confirmation.
- Impact requires sensitive data or destructive change: do not proceed; report safe evidence and request owner-approved validation.
- Conflicting evidence: preserve both, test a narrower explanation, or report uncertainty.

## Verification
Finding requires reproducible evidence of the asserted boundary failure and impact. Distinguish detection, attempted exploit, successful reproduction, code execution, and privilege level. Do not overstate CVSS/severity.

## Safety
Authorization for discovery does not automatically include exploitation, credential access, state modification, or data extraction. High-impact validation needs explicit action-specific approval.

## Evidence
Include scope source, affected asset, exact sanitized steps, expected/observed outcome, tool/version, impact basis, confidence/limitations, remediation, and retest steps. Never include secrets or unrelated personal data.
