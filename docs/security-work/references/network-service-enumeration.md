# Network service enumeration

## Coverage and host discovery

Start from the authorized target list, resolve names only as allowed, and record source/vantage, time, ports/protocols, rate, exclusions, and tool/version. Run bounded TCP discovery and UDP checks where relevant and permitted; UDP silence commonly remains `open|filtered`. Distinguish closed (explicit negative response), filtered (probe blocked/indeterminate), host unreachable, and unknown due to timeout. Follow discovery with targeted version probes, not a claim that all services were found. Firewalls, load balancers, virtual hosts, rate controls, and nonstandard ports limit coverage. Revisit a newly discovered host only after scope confirmation.

Use the [tool catalog](../tool-catalog/01-network-scanning.md) for scanner operations. Nmap is suitable for targeted stateful service detection; high-speed discovery tools yield candidates that need confirmation. Save structured output and exact coverage. A banner is not proof of installed version or patch state.

## Per-service record

For each relevant endpoint record host/port, TCP/UDP, service classification, observed product/version and confidence, how identified (direct banner vs probe/fingerprint), authentication, TLS/encryption, exposed capabilities, config checks, evidence, coverage limits, and next investigation. No service result grants permission to authenticate or modify data.

## Service-directed questions

| Service family | Safe first questions and follow-up |
|---|---|
| SSH / remote shell | Identify implementation and protocol, host key, negotiated algorithms, auth methods, and access policy. Availability is not login; login is not admin. Correlate banner with package/advisory evidence; no password guessing by default. |
| FTP / file transfer | Identify FTP/FTPS/SFTP distinction, TLS offered/required, anonymous policy, directory listing, and permissions using approved account. A successful connection is not read/write authorization; avoid uploads/deletes. |
| HTTP(S) | Establish TLS/SNI/virtual host, server/proxy clues, status, redirects, headers, cookies, app framework and auth flows. Map app via web reference; fingerprints are uncertain. |
| DNS | Query relevant A/AAAA/NS/MX/TXT/SRV; check resolver, authoritative context, and exposure. Zone transfer or brute-force tests need explicit permission. |
| SMTP/mail | Read greeting, STARTTLS/TLS policy, supported extensions and recipient policy through safe protocol checks. Avoid mail delivery/VRFY enumeration unless expressly approved. |
| SMB/RPC | Identify dialect, signing, auth context, guest behavior, share list/permissions and domain clues. List does not equal file read permission; use SMB/AD references. |
| RDP / WinRM | Identify listener/TLS/NLA or WinRM auth exposure. Establish approved account/interface before remote login; service presence does not mean admin access. |
| LDAP/LDAPS/Kerberos | Determine naming context, TLS, DC indicators and allowed read queries. If AD clues appear, route to [AD workflow](active-directory-enumeration.md). Ticket and auth operations need explicit approval. |
| NFS | Identify protocol versions, export metadata and client restrictions; do not mount/read files without authorization. Validate exports with owner and minimum metadata. |
| SNMP | Identify version/security model and permitted read-only system metadata. Avoid community guessing or SET operations; redact device details. |
| MySQL/PostgreSQL/MSSQL | Identify TLS/auth/version and accessible database metadata using authorized test identity. Login does not authorize data extraction or modification; query only minimum metadata. |
| Redis/MongoDB/Elasticsearch | Check TLS/auth and exposed API/version with minimal metadata request. Never enumerate documents/keys broadly; avoid config changes or destructive commands. |
| VNC / remote desktop | Check encryption/auth and supported protocol, not screenshots or interactive access absent permission. GUI capability is distinct from listener discovery. |
| VPN | Identify gateway protocol, certificate and auth exposure from approved docs/config. Do not attempt login or brute force; use owner-provided test identity. |
| Container/orchestration | Identify management endpoints and auth boundaries. Treat Docker/Kubernetes APIs as high impact; no commands that create workloads, exec, or alter config without explicit approval. |
| Queues/app servers/dev consoles | Fingerprint protocol/framework, auth, TLS, admin surface, and environment exposure. A development banner is a clue; verify owner/version and safe access before requests. |

Unknown or low-confidence services should receive a safe protocol-aware probe or owner clarification. If a probe fails, distinguish tool error, filtering, unsupported protocol, and negative evidence. Record what remains unknown. For CVE candidates, use the dedicated applicability workflow; do not jump from banner to exploit.
