# Security-work documentation

This documentation is stored under writable `docs/` because the workspace currently grants read-only access to `.agents/`. It is not a substitute for, nor automatically activated like, an agent skill. When `.agents/skills/security-work/` becomes writable, add a concise routing `SKILL.md` linking here and to the established `reliable-work` skill; do not duplicate these references. No live scan or exploit was run while preparing these files.

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
