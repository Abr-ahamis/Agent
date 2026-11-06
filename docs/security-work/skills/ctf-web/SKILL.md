---
{"name":"ctf-web","description":"Solve isolated web and API CTF challenges by tracing challenge logic, testing evidence-based hypotheses, and explaining a reproducible solution.","domain":"ctf","subdomains":["web","api","application logic"],"triggers":["web ctf","web challenge","ctf website","flag","SQL injection","XSS","SSRF","path traversal","JWT","GraphQL"],"excludes":["live bug bounty","production target"],"prerequisites":["Confirm isolated challenge or authorized lab endpoint; obtain supplied files, URL, and challenge constraints."],"tools":["curl","Browser DevTools","Burp Suite","OWASP ZAP","Source review"],"references":["../../references/web-application-enumeration.md","../../references/engagement-workflows.md","../../references/scope-and-authorization.md"]}
---
# Web and API CTF

## Methodology
1. Read prompt, files, host mapping, objective, and challenge boundaries; preserve artifacts and record hashes when useful.
2. Map routes and behavior with browser DevTools or single `curl -i` requests. Compare anonymous/authenticated behavior, cookies, redirects, errors, and request methods.
3. Inspect supplied source/config and client JavaScript first. Trace input from request to sink; identify framework, trust boundaries, and challenge-specific logic.
4. Build one hypothesis at a time: auth/access control, injection, traversal/include, upload, SSRF, template/deserialization, token validation, API/GraphQL authorization, or business logic. Change one variable and retain request/response evidence.
5. Use a proxy for replay and controlled comparison. Keep payloads harmless and within the isolated challenge. Infer only what output demonstrates.

Example: `curl -i 'http://challenge.local/item?id=7'` establishes response behavior only. Compare a nearby identifier or malformed value; an error alone is not proof of SQL injection. For source, search for query construction and parameterization, then reproduce the specific behavior.

## Decision
- Source exposes a risky sink: trace controllability and validation; test a minimal benign input in the challenge.
- No source: enumerate visible routes/forms/API descriptions and compare responses. If nothing appears, inspect static assets and challenge-provided hints before bounded wordlist discovery.
- Authenticated behavior differs: compare roles/identities if challenge accounts exist. A different status alone is not a bypass; establish protected data/action boundary.
- Injection hypothesis fails: verify the input reaches the suspected sink, encoding/content type, server-side normalization, and alternate relevant parameter. Stop repeating equivalent payloads.
- Endpoint found: assess authentication, object/function authorization, input handling, and business logic separately; discovery is not vulnerability.
- If static inspection cannot explain behavior, use controlled dynamic requests or local challenge instrumentation.

## Verification
Reproduce with the smallest request/change; establish the expected security boundary and observable bypass/impact. Rule out custom error pages, cache artifacts, client-only validation, and expected behavior. Stop once the flag or intended condition is demonstrated.

## Safety
Activate only for isolated CTF/lab environments. For any real host, switch to scope-gated bounty/assessment workflow; no testing based on a challenge-like hostname assumption.

## Evidence
Keep sanitized request/response pairs, route/input, challenge state, hypothesis, failed alternatives, and exact successful reproduction. Explain root cause and mitigation; do not claim tests not run.
