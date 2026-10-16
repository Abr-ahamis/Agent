# 02 — OSINT, DNS, and external reconnaissance

Passive sources can be stale, incomplete, or out of scope. Confirm the program permits use of third-party APIs and external data providers. Never treat a discovered hostname as authorization to probe it. API keys belong in a local secret manager/environment, never in chat or evidence.

### 11. Amass
- **Purpose / boundary:** OWASP Amass maps attack-surface assets through passive and active DNS methods; source coverage and DNS state are incomplete.
- **Mode / terminal:** CLI. Check `command -v amass; amass version; amass help`; configuration/API providers vary by release.
- **Example:** On a domain explicitly in scope, use the installed release's passive enum mode and write output under `<OUTPUT_FILE>`; inspect `amass enum -h` first because syntax changed between major versions. Do not enable active brute force by default.
- **Interpretation / next:** Names are leads, not proof of ownership or liveness. Resolve candidates, compare program scope, then only assess in-scope assets. Provider errors and missing keys reduce source coverage.
- **Troubleshooting/evidence:** Check config, providers, DNS, rate limits, and version migration docs. Save sources, command, scope, time, and rejected out-of-scope hosts. **UNVERIFIED**: [OWASP Amass docs](https://owasp.org/www-project-amass/).

### 12. Subfinder
- **Purpose / boundary:** Passive subdomain discovery through configured data sources; it does not validate reachability or authorization.
- **Mode / terminal:** CLI. Check `command -v subfinder; subfinder -version; subfinder -h`; inspect provider config without exposing keys.
- **Example:** `subfinder -d <AUTHORIZED_DOMAIN> -silent -o <OUTPUT_FILE>` is a passive lead-generation pattern; verify installed flags and program policy before querying sources.
- **Interpretation / next:** Deduplicate, preserve source context if available, resolve with `dnsx`/`dig`, and verify each name remains in scope. Empty output can mean no provider data/configuration, not no subdomains.
- **Troubleshooting/evidence:** Check API provider setup, DNS, rate limits, and config file permissions; redact secrets from logs. **UNVERIFIED**: [ProjectDiscovery Subfinder](https://docs.projectdiscovery.io/tools/subfinder/overview); no local test claimed.

### 13. Assetfinder
- **Purpose / boundary:** Finds related domains/subdomains from public sources; scope/ownership must be adjudicated separately.
- **Mode / terminal:** CLI. Check `command -v assetfinder; assetfinder -h`; Go build/version may not expose a version command.
- **Example:** `assetfinder --subs-only <AUTHORIZED_DOMAIN> > <OUTPUT_FILE>` after confirming local help. Use only as passive discovery unless additional behavior is explicitly authorized.
- **Interpretation / next:** Results are candidate names; resolve and compare against authoritative program scope. Do not follow redirects or scan linked hosts automatically.
- **Troubleshooting/evidence:** Empty output can reflect source drift or network restrictions; compare another permitted source and note dates. **UNVERIFIED**: [upstream repository](https://github.com/tomnomnom/assetfinder).

### 14. DNSrecon
- **Purpose / boundary:** DNS enumeration and configuration checks, including queries that can be active; not a guarantee of complete DNS inventory.
- **Mode / terminal:** CLI/Python package. Check `command -v dnsrecon; dnsrecon --help; dnsrecon --version` and interpreter/package environment.
- **Example:** Begin with a scoped standard record enumeration mode selected from local help; avoid brute force, zone transfer, or cache snooping unless specifically authorized.
- **Interpretation / next:** Records and findings are resolver observations; validate with `dig` against relevant servers. AXFR success can expose zone data and requires explicit permission.
- **Troubleshooting/evidence:** Check Python environment, resolver, option syntax, DNS timeouts, and rate restrictions. Store only in-scope answers. **UNVERIFIED**: [DNSrecon repository](https://github.com/darkoperator/dnsrecon).

### 15. dnsx
- **Purpose / boundary:** DNS query/resolve pipeline tool with record types, resolvers, and wildcard handling; not an ownership oracle.
- **Mode / terminal:** CLI. Check `command -v dnsx; dnsx -version; dnsx -h`; config/resolver support is version-specific.
- **Example:** `dnsx -l <IN_SCOPE_HOST_FILE> -a -resp -o <OUTPUT_FILE>`; verify options in installed help. Keep input lists scope-filtered before piping.
- **Interpretation / next:** Answers may include multiple A/AAAA/CNAME records and transient CDN edges. Compare TTLs and resolver context; use HTTP probing only after scope confirmation.
- **Troubleshooting/evidence:** Check malformed input, resolver limits, wildcard domains, and DNSSEC/network errors. **DOCUMENTED**: [upstream usage](https://github.com/projectdiscovery/dnsx); `-l`, `-a`, `-resp`, and `-o` workflow checked against upstream README, not local install.

### 16. Shodan
- **Purpose / boundary:** Hosted search engine over internet-observed service metadata; results are snapshots and do not authorize contacting the asset.
- **Mode / terminal:** Hosted web/API plus optional CLI/API client. Confirm account/API entitlement and program terms. Never place API tokens in command history.
- **Example:** Use the authenticated client/API query for an in-scope, organization-approved search; exact filters and CLI vary by account/client. Do not turn returned IPs into scan targets without scope confirmation.
- **Interpretation / next:** Banner, timestamp, port, and location are external observations, not current ground truth. Corroborate with owner-approved inventory/passive sources.
- **Troubleshooting/evidence:** Check API plan, quota, query syntax, stale data, and auth locally; redact account IDs/tokens. **UNVERIFIED**: [Shodan developer docs](https://developer.shodan.io/).

### 17. Censys
- **Purpose / boundary:** Hosted internet asset/certificate search and API; indexed data can be stale and is not authorization.
- **Mode / terminal:** Web/API service; CLI availability depends on product/client version. Check official account docs and client help; use local secret storage for credentials.
- **Example:** Query only a permitted search scope through the documented current API/client; no CLI syntax is asserted until the installed client/version is checked.
- **Interpretation / next:** Record observed time and dataset; validate ownership and current exposure through authorized channels before active tests.
- **Troubleshooting/evidence:** Distinguish API auth/quota errors from zero matches. Keep query, timestamp, response metadata, and redacted evidence. **UNVERIFIED**: [Censys docs](https://docs.censys.com/).

### 18. theHarvester
- **Purpose / boundary:** Collects public-source email, host, and related metadata for a scoped domain; source availability changes.
- **Mode / terminal:** CLI. Check `command -v theHarvester; theHarvester -h`; package naming and config vary.
- **Example:** Use the current help's domain and selected-source options with `<AUTHORIZED_DOMAIN>`, limiting to passive providers and saving `<OUTPUT_FILE>`.
- **Interpretation / next:** Returned emails/hosts are leads and may be stale or personal data; minimize retention, verify scope, and avoid contacting people or systems without authorization.
- **Troubleshooting/evidence:** Check provider keys, source-specific errors, network access, and version. Note sources and missing providers; redact personal data. **UNVERIFIED**: [upstream repository](https://github.com/laramies/theHarvester).

### 19. Recon-ng
- **Purpose / boundary:** Modular OSINT framework for structured collection and reporting; modules may call third-party services and expose sensitive data.
- **Mode / terminal:** Interactive CLI/workspaces. Check `command -v recon-ng; recon-ng -h`; inspect module help, marketplace/source, and API-key requirements before loading modules.
- **Example:** In a dedicated workspace, use help to inspect the selected passive module, configure approved provider credentials locally, then run against `<AUTHORIZED_DOMAIN>` and export to a controlled file. Avoid broad modules by default.
- **Interpretation / next:** Module output reflects source coverage and may be stale; record module/version/source and verify discovered assets against scope before follow-up.
- **Troubleshooting/evidence:** Resolve missing modules, keys, schema/network errors from module help and logs; never include secrets in exports. **UNVERIFIED**: [Recon-ng repository](https://github.com/lanmaster53/recon-ng).

### 20. SpiderFoot
- **Purpose / boundary:** OSINT automation correlating many data sources; broad module runs can disclose queries to providers and collect excess personal data.
- **Mode / terminal:** Web application with CLI/server components depending on release. Check install docs and `sf.py --help`/package entry point locally; GUI needs browser/session.
- **Example:** Create a named scan for an explicitly authorized seed, select a restrained passive module set, and export a redacted report. Verify current headless/API capabilities before automation.
- **Interpretation / next:** Findings are source-linked hypotheses; review provenance/confidence and scope each result before contacting a host.
- **Troubleshooting/evidence:** Check service bind address, database, module/API keys, quotas, and GUI availability. **UNVERIFIED**: [upstream documentation](https://www.spiderfoot.net/documentation/).

### 21. Maltego
- **Purpose / boundary:** GUI graph analysis and transforms for relationship mapping; graph edges are leads, not verified ownership or causality.
- **Mode / terminal:** Primarily GUI/web product with APIs/transforms governed by product edition. Verify edition and official automation support; no generic CLI workflow is assumed.
- **Example:** Human operator creates a scoped graph, runs specifically approved transforms, reviews each source, and exports a minimized graph. In terminal-only Codex, use documented APIs or source-specific CLI tools; do not claim GUI interaction.
- **Interpretation / next:** Validate each relationship from primary sources; use graph only to prioritize safe research.
- **Troubleshooting/evidence:** Check account/transform quotas, entitlement, connectivity, and graph provenance. **UNVERIFIED**: [Maltego documentation](https://docs.maltego.com/).

### 22. httpx
- **Purpose / boundary:** HTTP probing and metadata collection for supplied hosts; distinct from Python's `httpx` library.
- **Mode / terminal:** CLI. Check `command -v httpx; httpx -version; httpx -h`; confirm binary identity to avoid name collision.
- **Example:** `httpx -l <IN_SCOPE_HOST_FILE> -status-code -title -tech-detect -o <OUTPUT_FILE>`; confirm installed flags and keep request rate bounded.
- **Interpretation / next:** Status/title/TLS/technology fingerprints are observations, not exact version proof. Check virtual hosts and redirects carefully; send only in-scope requests, then map application functionality.
- **Troubleshooting/evidence:** Check resolver, TLS trust, HTTP/S scheme, timeouts, binary collision, and rate limits. **UNVERIFIED**: [ProjectDiscovery httpx](https://docs.projectdiscovery.io/tools/httpx/overview); no local execution claimed.
