# 04 — Web application and API security

Begin with ordinary application mapping and an authorized test account. Scanner alerts are leads; confirm manually with a minimal request. State edition/version requirements and distinguish GUI capabilities from terminal automation.

### 31. Burp Suite
- **Purpose / boundary:** Intercepting proxy, site map, manual testing, and (edition-dependent) scanning. It is hybrid GUI/automation; a terminal agent cannot claim GUI actions without GUI control.
- **Mode:** Hybrid GUI with edition/version-specific automation interfaces; no universal Burp CLI is assumed.
- **Terminal workflow:** Use `curl`/HTTPie for repeatable requests, or mitmproxy/mitmdump for CLI capture/replay. Burp APIs/enterprise automation are edition/version-specific; verify official docs and entitlement. GUI requires desktop, browser proxy, and controlled CA trust.
- **Example:** `curl -i --max-time 10 -H 'Cookie: <TEST_SESSION>' 'https://<AUTHORIZED_HOST>/<PATH>'` for a single approved request; never put real tokens in shell history. Save redacted request/response securely.
- **Interpretation/next:** Compare status, headers, cookies, body, and authorization across test accounts. curl does not reproduce Burp's interactive browser, extensions, or full scanner.
- **Troubleshooting/evidence:** Verify proxy routing, TLS CA, edition, listener, and scope; export sanitized evidence. **UNVERIFIED**: [PortSwigger docs](https://portswigger.net/burp/documentation); automation capabilities vary by product/version.

### 32. OWASP ZAP
- **Purpose / boundary:** Web proxy and automated/manual testing; active scan sends attack-like requests and needs explicit scope approval.
- **Mode / terminal:** GUI, daemon/API, packaged scans, and Automation Framework. Check `command -v zap.sh zaproxy; zap.sh -help`; use current official automation docs. Headless mode still needs configured context/auth and target.
- **Example:** A reviewed Automation Framework YAML via documented `-cmd -autorun <PLAN>` workflow on a designated lab/in-scope target; avoid unreviewed active scan jobs.
- **Interpretation/next:** Plan exit code indicates execution status, not zero vulnerabilities; alerts need manual validation and false-positive review.
- **Troubleshooting/evidence:** Check add-ons, API key/bind address, context, auth, plan schema, and warnings. Save plan, version, sanitized report. **DOCUMENTED**: [Automation Framework](https://www.zaproxy.org/docs/automate/automation-framework/), [automation options](https://www.zaproxy.org/docs/automate/); the documented `-cmd -autorun` workflow was checked against upstream docs, not run.

### 33. Caido
- **Purpose / boundary:** Web traffic interception and manual web testing; GUI-heavy with API/automation support dependent on version/edition.
- **Mode / terminal:** GUI application. Verify installed launcher and current API docs. Terminal alternative: curl/httpie for crafted requests or mitmproxy for capture/replay; neither duplicates all Caido workflows.
- **Example:** Use an authorized local proxy only if the installed release documents a headless/API mode; otherwise human operator configures browser proxy and exports selected, redacted flows.
- **Interpretation/next:** Compare requests/responses and session context; an intercepted request is not evidence of a vulnerability.
- **Troubleshooting/evidence:** Check graphical session, listener port, browser CA, license/features, and API version. **UNVERIFIED**: [Caido documentation](https://docs.caido.io/).

### 34. mitmproxy
- **Purpose / boundary:** CLI/TUI/web HTTP(S) proxy, flow capture/replay, and Python addons; it cannot reproduce browser-driven GUI scanners.
- **Mode / terminal:** CLI family `mitmproxy`, `mitmdump`, `mitmweb`. Check `command -v mitmproxy mitmdump mitmweb; mitmproxy --version; mitmdump --help`.
- **Example:** `mitmdump -w <FLOW_FILE> --listen-host 127.0.0.1 --listen-port <LOCAL_PORT>`; direct an authorized client through it and install its CA only in an isolated test profile. Confirm options locally.
- **Interpretation/next:** Flows show observed transactions, not all client traffic; certificate pinning, QUIC, or bypass paths can hide traffic. Replay only safe, authorized requests.
- **Troubleshooting/evidence:** Check proxy config, CA trust, bind exposure, TLS, and filters. Protect flow files as secrets. **PARTIALLY_VERIFIED**: [getting started](https://docs.mitmproxy.org/stable/overview/getting-started/), [commands](https://docs.mitmproxy.org/stable/concepts/commands/) confirm the CLI tool roles; capture flag details require installed-help review.

### 35. Postman
- **Purpose / boundary:** API client/collection runner for functional and authorized security checks; not a general vulnerability scanner.
- **Mode / terminal:** GUI desktop/web plus supported CLI runner (`Postman CLI`/Newman status is product-version-dependent). Check installed `postman --help` or `newman --help` and current official docs before automation.
- **Example:** Run a reviewed collection against `<AUTHORIZED_BASE_URL>` with environment variables supplied from a secure local store; never commit tokens or secrets. Confirm runner syntax/version first.
- **Interpretation/next:** Assertions test only programmed cases and environment; inspect response schema/status and authorization boundaries, then add minimal test cases.
- **Troubleshooting/evidence:** Check variable precedence, auth, TLS, runner compatibility, and secret redaction. **UNVERIFIED**: [Postman docs](https://learning.postman.com/docs/).

### 36. Nuclei
- **Purpose / boundary:** Template-driven detection for known exposures/misconfigurations; templates can actively probe and may create effects.
- **Mode / terminal:** CLI. Check `command -v nuclei; nuclei -version; nuclei -h`; inspect template source, severity, protocol, and tags before execution.
- **Example:** On an authorized lab host, run only a reviewed template file using the installed version's `-t` and output options; do not run broad templates by default.
- **Interpretation/next:** A match is a candidate requiring manual confirmation; template metadata/version and response evidence matter. Follow with prerequisite/CVE validation.
- **Troubleshooting/evidence:** Check template version, network timeout/rate, DNS/TLS, and malformed target. Save template hash, command, output, and redactions. **UNVERIFIED**: [ProjectDiscovery Nuclei](https://docs.projectdiscovery.io/tools/nuclei/overview).

### 37. Nikto
- **Purpose / boundary:** Web-server misconfiguration and known-file checks; noisy active requests, not a comprehensive modern app scanner.
- **Mode / terminal:** CLI. Check `command -v nikto; nikto -Version; nikto -Help`.
- **Example:** `nikto -host https://<AUTHORIZED_HOST> -output <OUTPUT_FILE> -Format json` only after verifying supported flags; apply scope, proxy, and throttling per current release.
- **Interpretation/next:** Findings often identify generic exposures; verify path/access and impact manually without retrieving sensitive content.
- **Troubleshooting/evidence:** Check TLS, plugins/database, proxy, virtual host, and timeout; output may contain false positives. **UNVERIFIED**: [official project site](https://cirt.net/Nikto2).

### 38. testssl.sh
- **Purpose / boundary:** TLS/SSL configuration inspection; network tests can be noisy and cover only a handshake/configuration snapshot.
- **Mode / terminal:** Shell script. Check `command -v testssl.sh; testssl.sh --version; testssl.sh --help`; verify OpenSSL/runtime and script provenance.
- **Example:** `testssl.sh --jsonfile <OUTPUT_FILE> <AUTHORIZED_HOST>:<PORT>` only after validating flags against installed help and limiting to an approved endpoint.
- **Interpretation/next:** Protocol/cipher/certificate results need context (client compatibility, load balancers, SNI); they do not establish application security.
- **Troubleshooting/evidence:** Check DNS/SNI, OpenSSL, network timeout, and script version; preserve sanitized JSON. **UNVERIFIED**: [upstream documentation](https://testssl.sh/).

### 39. WPScan
- **Purpose / boundary:** WordPress component/version and configuration assessment; API-token-backed vulnerability data has terms/quotas; active checks require scope.
- **Mode / terminal:** CLI. Check `command -v wpscan; wpscan --version; wpscan --help` and token config without exposing it.
- **Example:** `wpscan --url https://<AUTHORIZED_WP_HOST> --enumerate vp,vt --output <OUTPUT_FILE>` only with scope and local help confirmation; keep enumeration limited.
- **Interpretation/next:** Component fingerprint may be uncertain and version strings can be hidden/backported; correlate advisory and validate reachability/prerequisites.
- **Troubleshooting/evidence:** Check API quota, TLS, detection confidence, enumeration options, and rate limits. **UNVERIFIED**: [WPScan docs](https://wpscan.com/).

### 40. sqlmap
- **Purpose / boundary:** Automated SQL injection testing/exploitation; may alter data or invoke high-impact features. Use only on explicit authorized test targets and preferably lab copies.
- **Mode / terminal:** CLI. Check `command -v sqlmap; sqlmap --version; sqlmap -hh`; review technique/risk/level and side effects.
- **Example:** Start with a single approved captured request file and a minimal detection run; inspect help before selecting request-file and batch options. No data extraction, shell, or write operation is a default.
- **Interpretation/next:** A heuristic indication needs manual confirmation with a harmless Boolean/time test and application owner coordination; false positives and WAF interference occur.
- **Troubleshooting/evidence:** Verify request replay/auth/CSRF, parameter, proxy, rate, and DB behavior. Capture minimal redacted proof. **UNVERIFIED**: [sqlmap wiki](https://github.com/sqlmapproject/sqlmap/wiki).

### 41. Dalfox
- **Purpose / boundary:** XSS parameter scanner/validator; injected payloads are active and can affect users if executed.
- **Mode / terminal:** CLI. Check `command -v dalfox; dalfox version; dalfox help`; verify mode, rate, and output flags.
- **Example:** Test only a controlled reflection parameter on a lab or explicitly authorized endpoint; begin with non-executing/safe verification settings from current help.
- **Interpretation/next:** Reflections are not necessarily exploitable XSS; inspect context/encoding and browser execution in a safe test account.
- **Troubleshooting/evidence:** Check URL encoding, WAF/rate, auth/cookies, and false positives. Keep payload/response evidence harmless and redacted. **UNVERIFIED**: [upstream docs](https://github.com/hahwul/dalfox).

### 42. Arjun
- **Purpose / boundary:** Discovers accepted HTTP parameters; fuzz requests are active and may trigger application behavior.
- **Mode / terminal:** CLI. Check `command -v arjun; arjun --version; arjun -h` and wordlist/config options.
- **Example:** Run a low-rate parameter discovery against one authorized URL with the installed release's output option; preserve method, content type, and test account.
- **Interpretation/next:** Candidate parameters require ordinary request validation and access-control review; reflection or acceptance is not a vulnerability.
- **Troubleshooting/evidence:** Check baseline responses, rate limit, auth, method, and custom error behavior. **UNVERIFIED**: [upstream repository](https://github.com/s0md3v/Arjun).

### 43. jwt_tool
- **Purpose / boundary:** JWT inspection and security test helper; some modes attempt attacks or key guessing and require explicit authorization.
- **Mode / terminal:** Python CLI. Check `command -v jwt_tool.py jwt_tool; python --version; <entrypoint> -h` and source provenance.
- **Example:** Decode a redacted test token offline first; use a lab token for signature/claim tests. Never paste production tokens into third-party services or reports.
- **Interpretation/next:** Header/claims are attacker-controlled until signature and server validation are established; algorithm acceptance alone is not proof of bypass.
- **Troubleshooting/evidence:** Check Python dependencies, key format, token truncation, and version. Record sanitized claims and response evidence. **UNVERIFIED**: [upstream repository](https://github.com/ticarpi/jwt_tool).

### 44. Kiterunner
- **Purpose / boundary:** API route discovery using route dictionaries and HTTP probing; active requests can stress APIs.
- **Mode / terminal:** CLI. Check `command -v kr; kr help; kr version` and dictionary path/version.
- **Example:** Select a small API-specific dictionary and scan one authorized base URL with low concurrency and an output file; validate exact local syntax first.
- **Interpretation/next:** Route status/response signatures identify candidate endpoints, not authorization. Compare with API docs and test access controls using approved accounts.
- **Troubleshooting/evidence:** Check dictionary format, wildcard responses, TLS, auth, and throttling. **UNVERIFIED**: [upstream repository](https://github.com/assetnote/kiterunner).

### 45. SSRFmap
- **Purpose / boundary:** Framework for testing SSRF sinks and protocol behavior; can cause outbound access or interact with internal resources, so only isolated labs or explicit scope.
- **Mode / terminal:** Python CLI. Check repository install requirements, interpreter, and `--help`; review modules and callbacks before use.
- **Example:** Use a controlled lab callback endpoint and benign destination in a reviewed test configuration; do not target cloud metadata or third-party/internal hosts without explicit authorization.
- **Interpretation/next:** Callback demonstrates a specific outbound request path, not unrestricted internal access. Validate request controls and impact minimally.
- **Troubleshooting/evidence:** Check callback reachability, proxy/DNS, module prerequisites, and payload side effects. **UNVERIFIED**: [upstream repository](https://github.com/swisskyrepo/SSRFmap).

### 46. Commix
- **Purpose / boundary:** Command-injection detection/exploitation framework; exploitation can execute commands and alter targets, requiring explicit authorization.
- **Mode / terminal:** CLI. Check `command -v commix; commix --version; commix --help`; review detection/exploitation options for installed version.
- **Example:** Replay one authorized lab request with a harmless marker-only validation; do not request interactive shell or file write by default.
- **Interpretation/next:** Timing/error indicators need controlled repeat and application-owner awareness; distinguish server delays from command execution.
- **Troubleshooting/evidence:** Check request format, shell escaping, proxy, auth, timing, and WAF. Save minimal harmless proof and redacted request. **UNVERIFIED**: [upstream documentation](https://github.com/commixproject/commix).
