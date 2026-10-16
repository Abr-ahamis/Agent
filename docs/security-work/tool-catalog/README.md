# Security tool catalog

This catalog has one canonical numbered entry for each of the 100 requested tools. Each entry describes purpose and boundaries, operation mode and terminal path, availability checks, a scoped example, output interpretation, troubleshooting and follow-up, evidence, limits, and a primary reference. Examples use placeholders and are not claims of execution.

## Categories

1. [Network scanning and enumeration](01-network-scanning.md) — tools 01–10
2. [OSINT, DNS, and external reconnaissance](02-osint-dns-recon.md) — tools 11–22
3. [Website discovery and content enumeration](03-web-discovery.md) — tools 23–30
4. [Web application and API security](04-web-api-testing.md) — tools 31–46
5. [Exploitation and password auditing](05-exploitation-password-auditing.md) — tools 47–54
6. [Active Directory and Windows network security](06-active-directory-windows.md) — tools 55–68
7. [System enumeration and privilege escalation](07-system-enumeration-privesc.md) — tools 69–77
8. [Wireless and network security](08-wireless-security.md) — tools 78–81
9. [Reverse engineering and CTFs](09-reverse-engineering-ctf.md) — tools 82–92
10. [Forensics, file analysis, and cloud security](10-forensics-cloud-security.md) — tools 93–100

## Use and validation

Before use, confirm the assessment scope, tool availability, version, and mode. Read the individual entry; recheck local help and current official documentation for consequential or uncertain behavior. Choose the next tool from observed results, not from this inventory alone. Save only authorized, necessary, redacted evidence. No entry authorizes activity.

Status labels mean: `DOCUMENTED` = the stated procedure/options were checked in linked upstream documentation; `LOCAL_HELP_VERIFIED` = checked against this host's installed help; `LAB_TESTED` = executed successfully in a suitable authorized lab; `PARTIALLY_VERIFIED` = only some details checked; `UNVERIFIED` = procedure still needs checking; `NOT_APPLICABLE` = not relevant in this environment. Only specifically labeled details are documentation-checked; no procedure was checked against local help or executed in a lab for this catalog.

## Entry fields

Each numbered entry contains the tool's purpose and boundary, operation mode, availability/version/help checks or hosted prerequisites, scoped example, result interpretation and next step, troubleshooting, evidence guidance, source, and verification label. A version-sensitive or unresearched example remains explicitly `UNVERIFIED` and must be checked against installed help/current upstream documentation before consequential use.

## Common evidence record

Record tool/version, authorized input scope, exact redacted command or GUI/API operation, date, output artifact, observed result, interpretation, limitations, and next justified investigation. Keep credentials, tokens, unrelated personal data, and raw secrets out of general reports.
