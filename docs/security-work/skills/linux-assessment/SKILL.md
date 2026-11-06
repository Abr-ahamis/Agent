---
{"name":"linux-assessment","description":"Perform read-only, authorized Linux host inventory and privilege-escalation configuration analysis, validating every candidate path before reporting.","domain":"host assessment","subdomains":["Linux","privilege escalation","containers","services"],"triggers":["Linux assessment","Linux privilege escalation","SUID","sudo permissions","Linux host enumeration","Linux capabilities","cron security"],"excludes":["unauthorized shell access"],"prerequisites":["Confirm authorized host/access, current identity, permitted local commands, data handling, and whether changes or exploitation are allowed."],"tools":["Linux built-ins","LinPEAS","pspy","Linux Exploit Suggester","GTFOBins"],"references":["../../references/linux-enumeration.md","../../references/post-access-enumeration.md","../../references/authorized-exploit-validation.md"]}
---
# Linux host assessment

## Methodology
1. Record host, identity (`id`, `groups`), OS/release, architecture/kernel, uptime, and container/namespace context using read-only built-ins.
2. Inventory interfaces/routes/resolvers, listening sockets (`ss`), processes, mounts, packages, services and service identities. Do not probe neighboring systems without scope confirmation.
3. Review `sudo -l` as current identity, SUID/SGID, capabilities, cron/systemd units, file ACL/modes, writable paths, startup scripts, and relevant application configs. Do not print or copy secrets.
4. For each privilege path, connect all facts: current write/execute right, privileged consumer/identity, controllable input, timing/condition, and resulting capability. PEAS output is a lead only.

Example: `find / -xdev -type f -perm -4000 -print 2>/dev/null` is a bounded local inventory starting point, subject to filesystem/permission limits; a SUID file alone is not a vulnerability. Check package vendor advisories for kernel/application candidates and backports.

## Decision
- Command missing/permission denied: use an available built-in and record visibility limits; do not interpret missing output as absence.
- Writable privileged path candidate: inspect owning process/service configuration and execution semantics; do not modify or trigger it without explicit approval.
- CVE candidate: verify distro package/version and backport status, config, and prerequisites. Avoid exploit-suggester conclusions alone.
- Container indicator: assess mount/capability/runtime configuration read-only; do not escape or access host data without explicit scope.
- No path validated: summarize coverage and request additional approved access if needed.

## Verification
Confirm permissions as the current identity and trace actual privileged use. Do not run a payload to prove escalation unless specifically authorized. Distinguish configuration weakness from demonstrated privilege gain.

## Safety
Local access does not authorize pivoting, credential harvesting, service modification, persistence, or data collection. Default to read-only checks and least output.

## Evidence
Record identity, command, OS/kernel/package context, path owner/mode/ACL, relevant service/timer context, redacted output, and unverified assumptions.
