---
{"name":"windows-assessment","description":"Perform authorized, primarily read-only Windows workstation/server inventory, configuration review, and privilege-boundary analysis.","domain":"host assessment","subdomains":["Windows","PowerShell","privilege escalation","event logs"],"triggers":["Windows assessment","Windows privilege escalation","PowerShell security assessment","Windows server review","scheduled task permissions","token privileges"],"excludes":["unauthorized Windows host"],"prerequisites":["Confirm host and account scope, allowed local/remote methods, PowerShell constraints, data handling, and any explicitly approved state changes."],"tools":["PowerShell","Windows built-ins","Sysinternals","Seatbelt","WinPEAS"],"references":["../../references/windows-enumeration.md","../../references/active-directory-enumeration.md","../../references/authorized-exploit-validation.md"]}
---
# Windows host assessment

## Methodology
1. Record edition/build/architecture, hostname/domain, current token identity/groups/privileges, PowerShell edition/language limits, interfaces/routes/DNS and firewall context.
2. Inventory processes, services, executable paths, service identities, scheduled tasks, startup entries, installed software/updates, shares, listening ports, and relevant event log configuration.
3. Assess ACLs on privileged executables, parent directories, service/task configuration and referenced scripts. Validate actual write rights and privileged execution conditions; suspicious paths alone are not escalation proof.
4. Review token privileges and local groups; separate local admin, domain roles, and SYSTEM. For domain relationships, activate AD skill. Use Sysinternals/Seatbelt/WinPEAS only when present and approved; inspect collection scope and redact output.

Example: `whoami /all` shows token groups/privileges; it does not prove any privilege is exploitable. `Get-Service` provides service state/name; follow up on binary path, start identity and ACLs with read-only queries.

## Decision
- PowerShell unavailable/constrained: use built-ins/approved Sysinternals alternatives and document the gap.
- Weak service/task ACL suspected: verify effective write access and trigger conditions without changing configuration.
- Patch candidate: match exact build/update, vendor guidance/backports, configuration and prerequisites.
- Event logs/security policy relevant: query narrow time/source ranges and minimize sensitive data.
- No weakness validated: report what account and surface were observed; do not imply full host coverage.

## Verification
Use current-token permission checks and corroborate object ACL/configuration. Do not alter services/tasks or execute a privilege payload absent explicit approval. Report privilege level actually demonstrated.

## Safety
Do not dump credentials/hashes/tickets or bulk-read user data. Remote management, lateral movement, persistence and security-control changes require explicit authorization.

## Evidence
Record host/build, account/token context, command/tool version, ACL and service/task facts, timestamps, redactions, coverage limits, and remediation.
