# Windows enumeration

Begin with read-only local inspection after authorized access. For remote testing, first establish approved identity, host, interface, allowed method, and test window; RDP/SMB/WinRM presence does not imply usable access or admin rights.

## Local inventory

Use built-in commands and PowerShell where available to capture Windows edition/build/architecture, current identity/groups/privileges, hostname/domain join, interfaces/routes/DNS, connections/listening ports, processes/services, installed applications/updates, scheduled tasks/startups, shares, firewall rules, and relevant hosted components such as IIS. Check command availability, PowerShell edition/language constraints, and permissions before relying on output.

For each service record executable path, start identity, configuration, ACLs on executable/parent directories, and whether a user can alter a privileged execution path. A suspicious path is not a privilege-escalation proof until actual write access, service execution behavior, and safe preconditions are confirmed. Never change a service or scheduled task for validation without explicit approval.

## Access and boundaries

Distinguish ordinary user, delegated privilege, local Administrators, domain role, and SYSTEM based on actual token/group/privilege evidence. Validate shares with minimal metadata under the approved identity; listing a share is not permission to retrieve files. Assess authentication and remote management config without password guessing or bypassing policy.

Use Sysinternals, Autoruns, Seatbelt, WinPEAS, or PowerView only if their source/version/runtime is checked and collection is approved. Prefer narrow read-only queries. Tool output can contain paths, usernames, or secrets: redact and retain only needed evidence. Do not dump hashes, passwords, or tickets as routine inventory.

For candidate patches/CVEs, verify exact build/package, vendor update/backport context, configuration, and prerequisites. Report access level demonstrated, tests actually run, tool limitations, and retest steps.
