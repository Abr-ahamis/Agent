# 10 — Digital forensics, file analysis, and cloud security

Forensic evidence must remain intact: work from verified copies, hash source and derived artifacts, document chain of custody, and avoid uploading sensitive material to hosted services. Cloud assessment requires an authorized account/tenant and read-only identity where possible.

### 93. Volatility 3
- **Purpose / boundary:** Memory-forensics framework using OS plugins; plugin support depends on image symbols and captured memory context.
- **Mode / terminal:** Python CLI. Check `vol -h; vol --version` or package entrypoint and `python --version`; verify plugin list for version.
- **Example:** Analyze a hashed copy of `<AUTHORIZED_MEMORY_IMAGE>` with a documented identification plugin and output path; don't run acquisition or memory-modifying operations as analysis.
- **Interpretation/next:** Plugin results are artifacts at capture time; validate process/DLL/network relationships with multiple plugins and underlying offsets.
- **Troubleshooting/evidence:** Check symbol downloads/cache policy, image format, architecture, plugin availability, and memory integrity. **UNVERIFIED**: [Volatility 3 docs](https://volatility3.readthedocs.io/).

### 94. Autopsy
- **Purpose / boundary:** GUI digital-forensics case management for disk/image analysis; analysis modules can extract sensitive personal data.
- **Mode / terminal:** Primarily GUI, with separate Sleuth Kit CLI tools; do not assume a supported headless Autopsy mode. Verify current release docs and launcher.
- **Example:** Human examiner creates a case from a verified read-only image, records ingest modules and hashes, then exports only relevant artifacts. Terminal alternative: Sleuth Kit tools for specific filesystem questions, not full Autopsy equivalence.
- **Interpretation/next:** Artifacts depend on ingest configuration and time normalization; corroborate critical findings and preserve provenance.
- **Troubleshooting/evidence:** Check Java, case DB, image format, module errors, and graphical session. **UNVERIFIED**: [Autopsy docs](https://www.autopsy.com/support/).

### 95. YARA
- **Purpose / boundary:** Pattern-matching engine/rule language for files or memory; a match is a heuristic indicator, not malware attribution.
- **Mode / terminal:** CLI/library. Check `yara --version; yara --help` or `yarac --help`; inspect rule syntax and source.
- **Example:** Run a reviewed, versioned rule against a lab sample copy and save matches; restrict input paths and avoid scanning unrelated user data.
- **Interpretation/next:** Match means rule condition satisfied; inspect strings/condition and false-positive context, then use independent analysis.
- **Troubleshooting/evidence:** Check syntax, module availability, encoding, file limits, and rule version. Hash samples and redact. **UNVERIFIED**: [YARA docs](https://yara.readthedocs.io/).

### 96. Binwalk
- **Purpose / boundary:** Firmware/file signature and embedded-content analysis; extraction can create many files and malformed inputs may be risky.
- **Mode / terminal:** CLI. Check `binwalk --version; binwalk --help`; distinguish major versions and extractor dependencies.
- **Example:** Start with signature scan on a copy of `<INPUT_FILE>` and save text output; extraction is a separate step in a sandbox after reviewing reported offsets.
- **Interpretation/next:** Signatures/offsets are candidates; false positives and nested/compressed structures occur. Validate format with independent tools.
- **Troubleshooting/evidence:** Check file truncation, version, plugins, dependencies, and disk bounds. **UNVERIFIED**: [Binwalk repository](https://github.com/ReFirmLabs/binwalk).

### 97. CyberChef
- **Purpose / boundary:** Interactive data transformation/analysis recipes; user input may include secrets and hosted instances can disclose it.
- **Mode / terminal:** GUI web app, commonly locally hosted/static browser app; no universal CLI is assumed. Verify official deployment and any supported API for the version.
- **Example:** Use a local instance or terminal equivalents (e.g., OpenSSL/Python) for a reproducible transform; record exact operations and parameters. Do not paste production secrets into public instances.
- **Interpretation/next:** Output follows selected recipe and encoding; transformations are not proof of authenticity or safe decoding. Validate with independent implementations.
- **Troubleshooting/evidence:** Check operation order, character encoding, browser memory, and recipe export. **UNVERIFIED**: [CyberChef project](https://github.com/gchq/CyberChef).

### 98. RsaCtfTool
- **Purpose / boundary:** Research toolkit for RSA challenge key weaknesses; not a general key recovery service and should be used only on supplied/authorized keys.
- **Mode / terminal:** Python CLI. Check `python --version; RsaCtfTool.py --help`/actual entrypoint; inspect dependencies and current branch docs.
- **Example:** Use synthetic CTF public-key material offline with one documented analysis method; never submit private or customer keys to external services.
- **Interpretation/next:** A recovered factor/key applies to that input and weak parameter; validate cryptographic material independently and report safe remediation (adequate key generation).
- **Troubleshooting/evidence:** Check key format, Python dependencies, algorithm assumptions, and version. **UNVERIFIED**: [upstream repository](https://github.com/RsaCtfTool/RsaCtfTool).

### 99. Trivy
- **Purpose / boundary:** Scanner for container images, filesystems, repositories, SBOMs, and configuration; results depend on DB freshness and vulnerability matching.
- **Mode / terminal:** CLI. Check `command -v trivy; trivy --version; trivy --help`; inspect DB update/network behavior and cache.
- **Example:** `trivy image --scanners vuln,misconfig <AUTHORIZED_IMAGE_REF> --format json --output <OUTPUT_FILE>` only after checking current flags, registry access, and data-transfer policy. Prefer local image/digest.
- **Interpretation/next:** Findings need package/version, fixed-version, reachability, and deployment context review. Database match is not proof of exploitability.
- **Troubleshooting/evidence:** Check DB/cache age, registry auth, platform, unsupported OS, and exit-code semantics. **UNVERIFIED**: [Trivy docs](https://trivy.dev/latest/docs/).

### 100. Prowler
- **Purpose / boundary:** Cloud security posture checks (provider-specific); it queries real tenant configuration and may generate API cost/load.
- **Mode / terminal:** CLI. Check `command -v prowler; prowler --version; prowler --help`; verify supported provider/version, identity, and permissions.
- **Example:** Use a read-only assessment identity against the explicitly authorized lab/account and selected provider checks; confirm exact current CLI syntax and region/account scope before execution.
- **Interpretation/next:** A finding reflects a rule and observed config at scan time; validate exceptions, account context, and control applicability with owner.
- **Troubleshooting/evidence:** Check cloud credentials/profile without printing secrets, API permissions, quotas, region, and role session. Redact account IDs. **UNVERIFIED**: [Prowler docs](https://docs.prowler.com/).
