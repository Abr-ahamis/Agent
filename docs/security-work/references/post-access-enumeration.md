# Post-access enumeration

Post-access work begins only after access has been obtained within the expressly authorized objective. A shell/session does not itself authorize privilege escalation, persistence, credential use elsewhere, lateral movement, or data collection. Prefer low-impact, read-only checks; keep access duration and evidence minimal.

## Linux session

Record current identity/UID/groups/effective rights, host/OS/kernel/architecture, namespace/container context, network interfaces/routes/DNS, processes/services, listening sockets, mounts, package versions, service managers, scheduled jobs, and relevant application/runtime configuration. Inspect owner/mode/ACL/capability relationships and service execution identities. Use local built-ins first; run PEAS/pspy only if specifically allowed and reviewed.

Assess credential exposure by checking access controls and relevant configuration/backup/log locations, not by dumping contents. Do not print secrets. A candidate privilege path needs evidence that the current identity can control an input consumed by privileged execution and that all preconditions hold. Validate only through a safe approved demonstration.

## Windows session

Record user/token/groups/privileges, build/architecture/domain context, network configuration, processes/services, listeners, installed software/updates, tasks/startups, service paths/ACLs, shares, PowerShell constraints, firewall, IIS/hosted apps, and virtualization/container indicators. Distinguish ordinary access, local admin, domain rights, and SYSTEM by observed identity/token evidence.

Use native commands then narrow Sysinternals/Seatbelt/WinPEAS/PowerView queries where approved. Don't collect passwords, hashes, tickets, or unrelated personal data. Confirm any writable privileged service/task path and prerequisites before classifying it as exploitable; don't modify it without explicit approval.

## Internal surface and stop conditions

Local sockets and routes may reveal additional services; identify whether each is in the engagement scope before contacting it. Record attempted/completed checks and limitations. Stop and report on unexpected sensitive data, unstable service, scope ambiguity, or unapproved privilege boundary. Verify no changes occurred after any explicitly authorized test and document cleanup.
