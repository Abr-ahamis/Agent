# 07 — Linux and Windows system enumeration / privilege escalation

Use local enumeration after authorized access and begin with read-only identity, service, permission, and network context. A scanner's hint is a hypothesis: verify prerequisites and impact manually. Keep credentials/tickets out of output and reports.

### 69. LinPEAS
- **Purpose / boundary:** Linux privilege-escalation enumeration script that gathers broad host/configuration facts; noisy output can include sensitive paths/secrets.
- **Mode / terminal:** Shell script; check `command -v linpeas.sh` or inspect file metadata, source, hash, and `--help` if supported by that version. Do not download/run unreviewed copy.
- **Example:** In an authorized lab, review script source then run a locally approved copy with safe/read-only options and redirect output to protected `<OUTPUT_FILE>`; verify options in that exact version.
- **Interpretation/next:** Colored findings are leads, not confirmed escalation. Confirm owner/mode, execution context, and exploit preconditions with built-in commands.
- **Troubleshooting/evidence:** Check shell compatibility, permissions, restricted environment, output truncation, and script version. Redact secrets. **UNVERIFIED**: [PEASS-ng docs](https://github.com/peass-ng/PEASS-ng).

### 70. WinPEAS
- **Purpose / boundary:** Windows local privilege-escalation audit collector; may reveal sensitive config and trigger endpoint controls.
- **Mode / terminal:** Windows executable/batch variants. Verify release/signature/hash and use `--help`/version-matched docs; do not execute an unknown binary.
- **Example:** Authorized lab only; choose a documented read-only scan mode, collect output locally, and avoid upload or secret-dump options.
- **Interpretation/next:** Findings are candidates; inspect ACLs, service path, token rights, and exact build/prerequisites independently.
- **Troubleshooting/evidence:** Check architecture, .NET/runtime, command shell, AV policy, and output encoding. **UNVERIFIED**: [PEASS-ng docs](https://github.com/peass-ng/PEASS-ng).

### 71. pspy
- **Purpose / boundary:** Linux process monitor using procfs observation to reveal processes visible to the user; not a complete event monitor and can expose command arguments.
- **Mode / terminal:** CLI binary. Verify origin/hash/architecture and `pspy --help` if provided.
- **Example:** Run a reviewed, approved binary briefly in a lab and save only relevant process events; avoid collecting unrelated process arguments or secrets.
- **Interpretation/next:** A transient command suggests a scheduled/service execution path; inspect ownership, timing, and writable inputs without modifying them.
- **Troubleshooting/evidence:** Check procfs restrictions, kernel/container view, architecture, and permissions. **UNVERIFIED**: [upstream repository](https://github.com/DominicBreuker/pspy).

### 72. Linux Exploit Suggester
- **Purpose / boundary:** Maps kernel/package facts to possible known exploit references; version heuristics are especially prone to false positives/backports.
- **Mode / terminal:** Perl/shell scripts depending project. Check source, version, `--help`, and dependencies before running.
- **Example:** In an authorized lab, supply a minimal kernel/distribution inventory to a reviewed local copy; do not execute suggested exploits.
- **Interpretation/next:** Candidate list only. Check vendor advisory, exact package release, config, architecture, and backport status; validate safely in a matching lab.
- **Troubleshooting/evidence:** Check stale exploit DB, unknown distro, parsing mismatch, and incomplete package data. **UNVERIFIED**: [upstream project](https://github.com/The-Z-Labs/linux-exploit-suggester).

### 73. GTFOBins
- **Purpose / boundary:** Curated reference for Unix binaries that may escape restricted contexts or affect privileges; content is a research reference, not an instruction to exploit production.
- **Mode / terminal:** Web reference/static repository. Search via local browser/`grep` on a reviewed clone if present; no official executable is assumed.
- **Example:** Compare an observed binary/version and exact allowed context with its documented function; reproduce only in disposable CTF/lab.
- **Interpretation/next:** A listed technique applies only when permissions/config/version prerequisites match. Confirm benignly and document the boundary.
- **Troubleshooting/evidence:** Check stale page, function classification, shell/platform differences. **UNVERIFIED**: [GTFOBins](https://gtfobins.github.io/).

### 74. Seatbelt
- **Purpose / boundary:** Windows host security posture enumerator; collected output may contain sensitive system/account information.
- **Mode / terminal:** Windows .NET executable. Verify provenance, architecture/runtime, release help and source before use.
- **Example:** Use a reviewed read-only command group in an authorized lab and write output to a protected local artifact; avoid collection areas not needed.
- **Interpretation/next:** Results describe current context; validate a candidate ACL/service issue with native PowerShell/Windows access checks.
- **Troubleshooting/evidence:** Check .NET version, architecture, AV, policy, and command compatibility. **UNVERIFIED**: [GhostPack Seatbelt](https://github.com/GhostPack/Seatbelt).

### 75. PowerView
- **Purpose / boundary:** PowerShell AD discovery/relationship functions; command variants, module versions, and policy constraints matter.
- **Mode / terminal:** PowerShell module/script. Check trusted source, version metadata, local `Get-Command`/help; do not import unreviewed scripts.
- **Example:** In a domain where querying is authorized, use a specific read-only `Get-*` query with the current module help and narrow properties; avoid object modification functions.
- **Interpretation/next:** Output depends on current identity and directory ACLs; corroborate key ACL/delegation edges with LDAP/native tools.
- **Troubleshooting/evidence:** Check PowerShell edition/execution policy, module version, domain connectivity, and constrained language mode; do not bypass controls. **UNVERIFIED**: [PowerView project docs](https://github.com/PowerShellMafia/PowerSploit).

### 76. Sysinternals Suite
- **Purpose / boundary:** Microsoft Windows diagnostic utilities (e.g., Process Explorer, TCPView, Sigcheck); individual tools have different privileges and effects.
- **Mode / terminal:** Hybrid GUI/CLI. Check `where <UTILITY>`/`Get-Command`, `-?`, signature, and Microsoft Sysinternals docs. GUI utilities require an interactive desktop.
- **Example:** Prefer read-only `sigcheck`/`handle`/`listdlls` queries for the defined question; verify each command's own help and capture output. Do not terminate processes or change autoruns without approval.
- **Interpretation/next:** Process/signature/socket metadata are observations, not malware verdicts. Investigate suspicious paths/hashes through authorized sources.
- **Troubleshooting/evidence:** Check version, elevation, architecture, EULA, and GUI session. **UNVERIFIED**: [Microsoft Sysinternals](https://learn.microsoft.com/sysinternals/).

### 77. Autoruns
- **Purpose / boundary:** Enumerates Windows autostart locations; includes GUI and `autorunsc` CLI, but listing is not proof of malicious persistence.
- **Mode / terminal:** Hybrid. Check `where autorunsc.exe; autorunsc.exe -?`; verify Microsoft-signed package and current option docs.
- **Example:** Use CLI CSV output on an authorized host for inventory, with filters based on the exact help; do not uncheck/delete entries during assessment.
- **Interpretation/next:** Entry location, publisher, signature, and image path guide triage; verify hash and ACL/config before classifying.
- **Troubleshooting/evidence:** Check privileges, architecture, EULA, and output encoding. Preserve exported results securely. **UNVERIFIED**: [Autoruns for Windows](https://learn.microsoft.com/sysinternals/downloads/autoruns).
