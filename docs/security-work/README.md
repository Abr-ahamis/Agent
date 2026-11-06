# Security-work documentation

Security guidance lives under writable `docs/`. The framework-neutral router and operational skill corpus are in [`skills/`](skills/README.md); host applications must call that router because this repository contains no agent runtime. `.agents/` remains untouched because it is read-only here. Existing references provide deeper procedural detail; no live scan or exploit was run while preparing these files.

## Skill system

- [Skill authoring and router contract](skills/README.md)
- [Machine-readable tool registry](tools.json)
- [Composable investigation workflow](workflows/README.md)
- [Router and scope guard source](../../cybersecurity/)
- [Automated unit/scenario tests](../../tests/test_cybersecurity.py)

## Routes

- [Authorization and scope gate](references/scope-and-authorization.md)
- [Tool usage guide and 100-tool catalog](references/tool-usage-guide.md) ([catalog index](tool-catalog/README.md))
- [Network service enumeration](references/network-service-enumeration.md)
- [Linux enumeration](references/linux-enumeration.md)
- [Windows enumeration](references/windows-enumeration.md)
- [Active Directory enumeration](references/active-directory-enumeration.md)
- [Web application enumeration](references/web-application-enumeration.md)
- [Post-access enumeration](references/post-access-enumeration.md)
- [CVE research and validation](references/cve-research-and-validation.md)
- [Authorized exploit validation](references/authorized-exploit-validation.md)
- [Security reporting](references/security-reporting.md)
- [CTF, bounty, and pentest workflows](references/engagement-workflows.md)
- [Tool research and maintenance](../tool-knowledge-maintenance.md)

CTF, bounty, and formal assessment workflows share the scope gate and evidence requirements; adapt the depth and report format to the engagement. Catalog guidance is version-sensitive and must be checked against local help and current upstream docs before consequential use.
