# Linux enumeration

Use this sequence only after authorized local access or for a permitted configuration review. Start read-only, avoid collecting unrelated secrets, and treat every escalation idea as a hypothesis until prerequisites and effect are demonstrated.

## Remote vs local context

Remote network enumeration describes what a remote vantage can reach. Local authenticated enumeration describes what the current identity can see. Post-access enumeration is scoped to the approved foothold objective; a shell does not authorize pivoting. Record identity and source host for each observation.

## Initial system picture

Use available built-ins (`id`, `groups`, `hostname`, `/etc/os-release`, `uname -a`, `uptime`, `ip addr`, `ip route`, resolver config, `ps`, `ss -lntup`, `mount`, package-manager query) after checking platform syntax and permissions. These answer identity, OS/kernel, architecture, route, process, socket, mount, and package questions. Missing tools/restricted procfs mean incomplete visibility, not absence. Check container/namespace/virtualization indicators only as needed.

Map running services to owners, execution identities, local bind addresses, config files, and application runtimes. Compare external and local listening ports; local-only services may be reachable only from the host or an authorized segment. Do not probe related internal hosts without scope confirmation.

## Accounts, permissions, and execution

Record current UID/GID/groups and effective rights. Review authorized `sudo -l` output, relevant account/group metadata, service users, SSH config/key permissions, file owner/mode/ACLs, capabilities, SUID/SGID inventory, systemd units/timers and cron entries. Inspect only paths relevant to a hypothesis. A writable file matters for escalation only if a privileged process consumes it in a controllable way.

For potential paths, establish all links: who can write/execute, which privileged identity reads/runs it, timing/conditions, and expected impact. Do not execute payloads or alter services to prove a path without explicit authorization. GTFOBins/PEAS findings are leads; manually verify version/config/permissions.

## Applications, packages, and exposure

Check installed package versions and vendor patches; inspect only relevant application deployments, backup/archive/log/temp paths, environment/service configuration, container mounts, and secret-file permissions. Do not print credentials or bulk-read home directories. If exposure needs proof, capture file metadata and a redacted minimal excerpt only when authorized. Hash artifacts where forensic integrity matters.

Use `linpeas`, `pspy`, or Linux Exploit Suggester only when available, reviewed, and allowed. Save bounded output securely and treat results as hypotheses. Verify package/backport status with distribution advisories before CVE claims. Report what identity could access, what was actually validated, limitations, and remediation.
