---
{"name":"bug-bounty-web-api","description":"Run evidence-led, low-impact web/API bug bounty testing after reading program scope, exclusions, rate limits, and prohibited techniques.","domain":"bug bounty","subdomains":["web","API","auth","access control","business logic"],"triggers":["bug bounty","bounty program","in-scope web target","web application assessment","API assessment","GraphQL testing","OAuth assessment"],"excludes":["out of scope","production exploit without authorization"],"prerequisites":["Record program URL/rules, exact assets, exclusions, rate limits, test accounts, allowed techniques, data-handling rules, and stop conditions."],"tools":["Burp Suite","OWASP ZAP","curl","Browser DevTools","ffuf","Nuclei"],"references":["../../references/scope-and-authorization.md","../../references/web-application-enumeration.md","../../references/authorized-exploit-validation.md","../../references/security-reporting.md","checklists.md"]}
---
# Bug bounty web and API assessment

## Methodology
1. Read current program rules and establish exact host/path/account scope, third-party boundaries, request rate, and prohibited tests. Scope is never inferred from DNS or redirects.
2. Map routes, roles, API descriptions, JavaScript references, auth/recovery flows, cookies, CORS, cache behavior, and technologies with passive or low-rate methods. Record observations separately from fingerprint guesses.
3. Prioritize hypotheses from reachable code paths and account roles. Compare same request as two authorized accounts for IDOR/function access. Test one class at a time; discovery alone is not vulnerability.
4. Keep requests low-rate and state-safe. For race conditions or stateful logic, confirm program rules and use minimal isolated test objects/accounts. Stop after minimum impact is demonstrated.

## Checklist and interpretation
- **Auth/session/recovery/OAuth/JWT:** inspect cookie flags, rotation, invalidation, redirect URI/state/nonce, token issuer/audience/expiry/key handling, recovery binding/expiry. Positive only if a controlled account crosses an auth boundary; malformed token acceptance alone is not impact.
- **Authorization/IDOR/API/GraphQL:** compare object and function access across owned test accounts/roles; vary IDs, methods, fields, nested resolvers. Confirm access to a second account's controlled fixture without touching unrelated data. A 200 or schema exposure alone is not proof.
- **Input/injection/XSS/SSRF/upload/path traversal:** trace input to a relevant server/client sink; use harmless markers and approved callback infrastructure. Verify execution/read/interaction under controlled data. Reflections and scanner payload matches are not proof.
- **CSRF/CORS/cache/smuggling/rate limits/races:** establish prerequisites, browser context, cache key/poisoning boundary, parser disagreement, actual enforcement, or repeatable state race. Use only explicitly permitted low-impact validation; parser desync and race tests can affect shared systems.
- **Business logic/information disclosure:** model intended invariant and roles; compare allowed vs disallowed transitions. Redact and stop at the minimum sensitive proof.

Tools: proxy/manual replay supports controlled comparisons; `curl` gives reproducible single requests; scoped crawlers/fuzzers need bounded rate/depth and baseline error comparison; scanners produce leads only. Review source maps/JS for routes and secret exposure without using discovered credentials.

## Decision
- No surface discovered: inspect authorized JS/API docs and app navigation; use a small scoped wordlist only if rules allow. Stop on rate/instability signals.
- Hypothesis negative: verify account role, content type, normalization, cache/session context, and actual server-side path; change one assumption. Do not iterate payload lists without a mechanism.
- Candidate issue found: reproduce with controlled accounts/data, compare expected boundary, rule out cache/error/test setup, and validate minimal impact.
- Out-of-scope redirect, unexpected sensitive data, instability, or unclear rule: stop and report to program as required.

## Verification
Use a fresh session/request and a second controlled account or object where relevant. Capture minimal redacted evidence. Distinguish CONFIRMED from likely/unverified; never claim exploitability from endpoint discovery, banner, scanner output, or reflection alone.

## Safety
No destructive testing, DoS, phishing, persistence, credential attacks, broad data extraction, or third-party testing. Intrusive/high-impact methods require explicit program authorization. Follow rate limits and stop rules.

## Evidence
Store scope source/version/date, redacted request-response, identities/roles, endpoint, exact test conditions, expected vs observed outcome, impact, limits, and remediation. Submit only through authorized program channel after review.
