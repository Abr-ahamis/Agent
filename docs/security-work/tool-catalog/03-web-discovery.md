# 03 — Website discovery and content enumeration

Use passive archives before active crawling where useful. Active crawling/fuzzing requires scope, acceptable request rates, and stop criteria. Establish a baseline for nonexistent paths; false positives from custom 200/404 pages are common. Do not automatically retrieve sensitive candidate files.

### 23. gau
- **Purpose / boundary:** Fetches known URLs from public archival/source providers; it does not establish that a URL is currently live or in scope.
- **Mode / terminal:** CLI. Check `command -v gau; gau --version; gau -h`; provider behavior and options vary by release.
- **Example:** `gau <AUTHORIZED_DOMAIN> --o <OUTPUT_FILE>` only after local help confirms syntax and program rules allow third-party lookups.
- **Interpretation / next:** Deduplicate and scope-filter URLs, then issue minimal authorized HEAD/GET checks. Archive parameters are leads, not vulnerabilities.
- **Troubleshooting/evidence:** Check provider availability, domain syntax, API rate limits, and stale results; retain source/date. **UNVERIFIED**: [upstream repository](https://github.com/lc/gau).

### 24. waybackurls
- **Purpose / boundary:** Retrieves archived URLs from the Internet Archive for a domain; not a live crawler or authorization source.
- **Mode / terminal:** CLI stream filter. Check `command -v waybackurls; waybackurls -h` or repository docs; releases may offer limited flags.
- **Example:** `printf '%s\n' <AUTHORIZED_DOMAIN> | waybackurls > <OUTPUT_FILE>` after verifying input behavior locally. Do not feed discovered unrelated domains into active tests.
- **Interpretation / next:** Historical paths may no longer exist; scope-filter, deduplicate, compare with current app routes, and verify minimally.
- **Troubleshooting/evidence:** Check stdin, provider reachability, throttling, and empty archives. **UNVERIFIED**: [upstream repository](https://github.com/tomnomnom/waybackurls).

### 25. Katana
- **Purpose / boundary:** Web crawler for reachable URLs and JavaScript-linked routes; active crawling can generate requests and miss authenticated/client-only flows.
- **Mode / terminal:** CLI. Check `command -v katana; katana -version; katana -h`.
- **Example:** `katana -u <AUTHORIZED_URL> -d <SMALL_DEPTH> -jc -o <OUTPUT_FILE>` only after validating options and rate controls in local help.
- **Interpretation / next:** URL output reflects crawl seeds, depth, scope rules, and runtime behavior; it does not prove endpoint authorization or security impact. Review candidate routes and inspect app features.
- **Troubleshooting/evidence:** Check TLS, robots/scope settings, JS engine requirements, depth, and throttling. Record seed/depth/rate. **UNVERIFIED**: [ProjectDiscovery Katana](https://docs.projectdiscovery.io/tools/katana/overview).

### 26. ffuf
- **Purpose / boundary:** HTTP request fuzzer for content, virtual hosts, parameters, and inputs; request volume can affect service stability.
- **Mode / terminal:** CLI. Check `command -v ffuf; ffuf -V; ffuf -h`; require an approved wordlist and target.
- **Example:** `ffuf -w <APPROPRIATE_WORDLIST> -u 'https://<AUTHORIZED_HOST>/FUZZ' -rate <APPROVED_RATE> -of json -o <OUTPUT_FILE>`; confirm options in installed help. Establish random nonexistent-path baseline and calibrate filters.
- **Interpretation / next:** Status, size, words, lines, redirects, and timing distinguish candidates; wildcard/error templates create false positives. Verify a candidate with one minimal request before expanding.
- **Troubleshooting/evidence:** Check FUZZ placement, URL encoding, wordlist path, baseline, rate, and response filters. **PARTIALLY_VERIFIED**: [ffuf usage](https://github.com/ffuf/ffuf/wiki) documents `-w` and `-u`/`FUZZ` pattern; output/rate options need installed-help review.

### 27. Gobuster
- **Purpose / boundary:** Directory/file, DNS, or virtual-host discovery via explicit modes; not a vulnerability scanner.
- **Mode / terminal:** CLI. Check `command -v gobuster; gobuster version; gobuster help` and selected mode help.
- **Example:** `gobuster dir -u https://<AUTHORIZED_HOST>/ -w <WORDLIST> -o <OUTPUT_FILE> -t <LOW_THREAD_COUNT>` after verifying installed version and scope/rate policy.
- **Interpretation / next:** Status, length, and redirects are candidates; calibrate against custom not-found behavior and inspect only relevant results.
- **Troubleshooting/evidence:** Mode mismatch, TLS, wordlist, threads/rate, and wildcard responses commonly confuse results. **UNVERIFIED**: [upstream repository](https://github.com/OJ/gobuster).

### 28. Feroxbuster
- **Purpose / boundary:** Recursive content discovery; recursion can multiply request volume, so cap depth, extensions, and rate.
- **Mode / terminal:** CLI. Check `command -v feroxbuster; feroxbuster --version; feroxbuster --help`.
- **Example:** `feroxbuster -u https://<AUTHORIZED_HOST>/ -w <WORDLIST> --depth <SMALL_DEPTH> --rate-limit <APPROVED_RATE> -o <OUTPUT_FILE>` only if local help confirms options.
- **Interpretation / next:** Status/size/path findings are subject to recursion and error-page noise. Review the crawl boundary, then validate specific paths without fetching sensitive content.
- **Troubleshooting/evidence:** Check recursion loops, filters, TLS, proxy, wordlist, and server stress. Stop if instability appears. **UNVERIFIED**: [official project docs](https://epi052.github.io/feroxbuster-docs/).

### 29. dirsearch
- **Purpose / boundary:** Web path discovery with extensions, recursion, and request customization; active requests require authorization and conservative settings.
- **Mode / terminal:** Python CLI. Check `command -v dirsearch; dirsearch --version; dirsearch -h`; inspect Python/dependency and config state.
- **Example:** `dirsearch -u https://<AUTHORIZED_HOST>/ -w <WORDLIST> --format=json -o <OUTPUT_FILE>` only after confirming options for installed release and setting its supported delay/thread controls.
- **Interpretation / next:** Response codes, sizes, redirects, and extension results need baseline filtering. Verify likely resources minimally; don't automatically open backups/configs.
- **Troubleshooting/evidence:** Check Python environment, proxy/TLS, wordlist, custom 404, and rate limits. **UNVERIFIED**: [upstream documentation](https://github.com/maurosoria/dirsearch).

### 30. GoWitness
- **Purpose / boundary:** Captures screenshots/metadata for web endpoints to support visual triage; does not test application security.
- **Mode / terminal:** CLI with browser/headless-browser dependencies depending on release. Check `command -v gowitness; gowitness version; gowitness --help` and browser dependency docs.
- **Example:** Use the current release's scan command with a scope-filtered URL list and explicit output directory; verify subcommand syntax locally before running.
- **Interpretation / next:** Screenshots can reveal login/admin pages but may contain personal or secret data; review and redact. A blank screenshot may be JS, auth, proxy, or browser failure.
- **Troubleshooting/evidence:** Check Chromium/browser installation, sandbox restrictions, certificates, concurrency, and output path. Save only necessary screenshots. **UNVERIFIED**: [upstream docs](https://github.com/sensepost/gowitness).
