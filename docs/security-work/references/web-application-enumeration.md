# Web application and API enumeration

Map observable app behavior before vulnerability checks. Confirm scheme/host/path scope, redirects, test account, allowed request rate, and state-changing limits. Do not guess credentials or automatically follow linked hosts outside scope.

## Fingerprint and map

Use complementary evidence: response headers/cookies/TLS, static assets and JavaScript, HTML, error behavior, framework/CMS clues, API descriptions, CDN/proxy indicators, and authenticated user-visible routes. Record direct observations separately from fingerprint guesses; banners do not prove exact patch level. Check landing/linked pages, login/logout/recovery/registration, discovered admin surfaces, API routes, forms/parameters/uploads, redirects/access boundaries, source maps/build artifacts, and errors. Do not expose secrets discovered in client files.

Use passive URL archives where policy permits, then scoped crawling. `ffuf`, Gobuster, Feroxbuster, dirsearch, and Kiterunner need a relevant small wordlist, bounded rate/depth/concurrency, and stop condition. First measure random nonexistent paths and custom error responses; compare status, length, title, redirect, and body patterns. Candidate backups/configs should be verified with minimal metadata/request and never bulk-downloaded.

## Select tests from evidence

Use a proxy/manual workflow for authentication and authorization comparisons. Test only relevant classes: access control/IDOR with two approved accounts, session handling, injection where an input reaches a sink, XSS in a controlled browser/context, SSRF with an approved callback, upload/path handling, exposed config, API authorization, and component CVEs after applicability checks. Avoid scanners on every target by default. Scanner matches require repeatable manual proof and evidence.

Stop if requests cause instability, unexpected state changes, or sensitive data exposure. Record app routes and tested/not-tested areas. For CLI-first operation, curl/HTTPie provide reproducible single requests; mitmproxy/mitmdump provide terminal flow capture/replay; ZAP's API/Automation Framework supports documented automation. These do not reproduce every Burp/Caido GUI, browser, extension, or commercial scanning capability.
