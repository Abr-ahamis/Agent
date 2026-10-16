# 06 — Active Directory and Windows network security

Use domain tools only in a named, authorized environment. Record identity, domain, DC, authentication mechanism, permissions, and scope. Distinguish read-only queries from authentication attempts, ticket operations, relaying, object changes, and remote execution; the latter need explicit approval for that operation.

### 55. Impacket
- **Purpose / boundary:** Python protocol implementation suite for SMB, MSRPC, LDAP, Kerberos, and Windows administration/testing; each script has distinct effects.
- **Mode / terminal:** CLI scripts/library. Check `python -m pip show impacket`, installed entrypoint names, and each script's `-h`; names differ by packaging.
- **Example:** Inspect help for a read-only directory query such as `GetADUsers.py -h`; use only approved DC/domain and test credentials via protected local input. Do not run exec, secrets-dump, relay, or ticket tools by default.
- **Interpretation/next:** Output depends on account rights and protocol; empty results do not prove no objects. Corroborate with LDAP/Windows-native views and record auth context.
- **Troubleshooting/evidence:** Check Python version, package source, DNS/time, Kerberos cache, and SMB signing/TLS. **UNVERIFIED**: [upstream docs](https://github.com/fortra/impacket).

### 56. NetExec
- **Purpose / boundary:** Network authentication and service enumeration framework (successor ecosystem to CrackMapExec); modules can authenticate or execute commands.
- **Mode / terminal:** CLI. Check `command -v nxc; nxc --version; nxc --help; nxc <protocol> --help`; inspect module help.
- **Example:** Use a single authorized host and a read-only information module with a dedicated test account. Avoid password spraying, credential dumping, or command execution unless explicitly in scope.
- **Interpretation/next:** Auth success establishes that credential works for that service, not admin rights. Validate listed shares/rights minimally and document protocol/auth context.
- **Troubleshooting/evidence:** Check binary naming, Python env, DNS, SMB dialect, lockout policy, and auth errors. **UNVERIFIED**: [NetExec docs](https://www.netexec.wiki/).

### 57. BloodHound CE
- **Purpose / boundary:** Graph-based AD relationship analysis; it visualizes collected data and proposes paths, not verified compromise.
- **Mode / terminal:** Server/web UI plus APIs/importer; collection often via SharpHound. Check deployment docs, service health, and current API/import methods. Human UI workflow may be unavailable to terminal-only Codex.
- **Example:** In an authorized lab, import least-privilege collected data into an isolated CE instance, run reviewed queries, and export only relevant graph evidence.
- **Interpretation/next:** Edge/path depends on stale/incomplete collection and modeled semantics; validate each permission on the actual object before stating exploitability.
- **Troubleshooting/evidence:** Check CE version/schema, database, collector compatibility, and timestamps. Protect datasets as sensitive directory metadata. **UNVERIFIED**: [BloodHound docs](https://bloodhound.specterops.io/).

### 58. SharpHound
- **Purpose / boundary:** BloodHound data collector for Windows/AD; collection can query many domain objects and create detectable network load.
- **Mode / terminal:** Windows executable/PowerShell collector with documented options depending release. Check file provenance, signature/hash, `SharpHound.exe --help` or version-matched docs before use.
- **Example:** Use only an approved collection method and narrow collection scope in a lab/engagement; no broad all-data collection by default.
- **Interpretation/next:** Collection output is a snapshot and may be incomplete due to access/ACLs. Import into matching CE schema, then validate high-impact edges directly.
- **Troubleshooting/evidence:** Check .NET/runtime, AV policy, version compatibility, DNS/domain context, and output protection. **UNVERIFIED**: [BloodHound collection docs](https://bloodhound.specterops.io/collect-data/).

### 59. Certipy
- **Purpose / boundary:** AD CS enumeration and assessment; some functions request certificates or authenticate as identities and require explicit authorization.
- **Mode / terminal:** Python CLI. Check `command -v certipy; certipy -h; certipy <subcommand> -h`; validate version-specific syntax.
- **Example:** Read current help for the read-only `find` workflow, scope it to the authorized domain/DC, and use a dedicated account. Do not request/relay certificates as a default check.
- **Interpretation/next:** Template flags identify candidate misconfiguration; confirm enrollment ACLs, EKUs, CA policy, and prerequisites before severity claims.
- **Troubleshooting/evidence:** Check DNS/DC, auth context, Python package, CA reachability, and schema/version. **UNVERIFIED**: [Certipy docs](https://github.com/ly4k/Certipy).

### 60. Kerbrute
- **Purpose / boundary:** Kerberos username discovery and authentication auditing; requests can reveal valid principals and may trigger defenses.
- **Mode / terminal:** CLI. Check `command -v kerbrute; kerbrute -h; kerbrute <command> -h`.
- **Example:** Username enumeration only on an approved lab domain, with an approved list/rate and named DC; avoid password spraying unless explicitly authorized with lockout controls.
- **Interpretation/next:** Responses vary with pre-auth policy, timing, and DC; a valid principal is not a valid credential. Corroborate via LDAP/authorized inventory.
- **Troubleshooting/evidence:** Check time skew, DNS/DC discovery, Kerberos realm, rate, and network path. Minimize retained usernames. **UNVERIFIED**: [upstream repository](https://github.com/ropnop/kerbrute).

### 61. Responder
- **Purpose / boundary:** LLMNR/NBT-NS/mDNS responder and protocol analysis tool; poisoning may capture authentication material and affect network clients.
- **Mode / terminal:** CLI. Check `command -v responder; responder --help`; inspect config and interface before use.
- **Example:** Passive analysis in an isolated lab only unless the engagement explicitly authorizes a controlled poisoning test; no credential capture/reuse recipe is provided.
- **Interpretation/next:** Name-resolution traffic indicates client behavior, not permission to authenticate. Report exposure with redacted evidence and recommend protocol hardening.
- **Troubleshooting/evidence:** Check interface, privileges, network segment, competing services, and config; stop if unexpected traffic/impact occurs. **UNVERIFIED**: [upstream documentation](https://github.com/SpiderLabs/Responder).

### 62. ntlmrelayx
- **Purpose / boundary:** Impacket relay testing; relaying can obtain unauthorized access or modify systems and is high impact.
- **Mode / terminal:** CLI Python tool. Check exact installed `ntlmrelayx.py -h`, Impacket version, and module prerequisites.
- **Example:** No reusable relay command is supplied. Use only a specifically approved isolated lab plan with named endpoints, no unintended targets, a reviewed config, and a stop/cleanup procedure.
- **Interpretation/next:** A relay attempt is not proof of compromise; verify the explicitly approved control outcome and restore state. Do not expand from one host to discovered peers.
- **Troubleshooting/evidence:** Validate SMB signing/channel binding/LDAP protections in a safe configuration review before any active test. **UNVERIFIED**: [Impacket repository](https://github.com/fortra/impacket).

### 63. enum4linux-ng
- **Purpose / boundary:** SMB/RPC/LDAP information enumeration for Windows/Samba; output is limited by guest/auth permissions and server policy.
- **Mode / terminal:** Python CLI. Check `command -v enum4linux-ng; enum4linux-ng -h; python --version`.
- **Example:** `enum4linux-ng -A <AUTHORIZED_HOST> -oA <OUTPUT_PREFIX>` only when local help confirms flags and the host is in scope; prefer narrowly requested checks if available.
- **Interpretation/next:** Null/guest access, users, groups, shares, and policy data are observations under one auth context; empty output may mean restricted enumeration.
- **Troubleshooting/evidence:** Check SMB reachability, Python dependencies, RPC ports, credentials, and dialect support. Redact user lists. **UNVERIFIED**: [upstream repository](https://github.com/cddmp/enum4linux-ng).

### 64. smbclient
- **Purpose / boundary:** Samba SMB client for share listing and file operations; writes/deletes are possible and must be avoided unless authorized.
- **Mode / terminal:** CLI. Check `command -v smbclient; smbclient --version; smbclient --help`.
- **Example:** `smbclient -L //<AUTHORIZED_HOST> -N` tests anonymous listing only; do not infer permission to read files. Use a protected credential mechanism for approved auth; avoid inline passwords.
- **Interpretation/next:** Share list is not share access; test one permitted share with minimal metadata listing and no file download unless necessary.
- **Troubleshooting/evidence:** Check SMB version, signing, auth domain, DNS, and port reachability. Record identity and redacted result. **UNVERIFIED**: [Samba smbclient manual](https://www.samba.org/samba/docs/current/man-html/smbclient.1.html).

### 65. ldapsearch
- **Purpose / boundary:** OpenLDAP CLI for LDAP/LDAPS queries; query scope and returned personal data must be minimized.
- **Mode / terminal:** CLI. Check `command -v ldapsearch; ldapsearch -VV; man ldapsearch`.
- **Example:** `ldapsearch -x -H ldaps://<AUTHORIZED_DC> -b '<APPROVED_BASE_DN>' '(objectClass=domain)' dn` is a narrow query pattern; verify TLS trust and base DN locally.
- **Interpretation/next:** LDAP result codes, referrals, controls, and ACL-filtered attributes matter; lack of results may be permissions or wrong naming context.
- **Troubleshooting/evidence:** Check DNS, TLS cert, bind method, base DN, escaping, and timeouts. Save only necessary attributes. **UNVERIFIED**: [OpenLDAP ldapsearch manual](https://www.openldap.org/software/man.cgi?query=ldapsearch).

### 66. Evil-WinRM
- **Purpose / boundary:** WinRM client for authorized Windows remote administration/lab shells; successful login provides a session, not necessarily admin or SYSTEM.
- **Mode / terminal:** Ruby CLI. Check `command -v evil-winrm; evil-winrm -h; ruby --version` and current authentication support.
- **Example:** Connect only to a named in-scope host with an approved test account via protected local credential input; no password literals in shell history. Begin with identity/context inspection.
- **Interpretation/next:** Confirm `whoami`/groups and allowed session capabilities; shell acquisition is not authorization for lateral movement or persistence.
- **Troubleshooting/evidence:** Check WinRM listener, TLS/HTTP policy, auth, Ruby dependencies, and firewall. **UNVERIFIED**: [upstream repository](https://github.com/Hackplayers/evil-winrm).

### 67. Mimikatz
- **Purpose / boundary:** Windows security research utility with credential/ticket extraction and system manipulation capabilities; high-risk, sensitive, and commonly restricted.
- **Mode / terminal:** Windows CLI/interactive executable. Verify binary source/signature, version, and lab policy; do not download or run unknown builds.
- **Example:** No credential extraction command is provided. Use Windows built-in identity/privilege inspection for routine assessment; any authorized lab demonstration must be specifically approved and use synthetic accounts.
- **Interpretation/next:** Tool output can expose secrets and is not proof that credentials work elsewhere. Preserve only minimal redacted evidence; never reuse discovered credentials.
- **Troubleshooting/evidence:** AV/EDR blocks and privilege requirements are safety controls, not obstacles to bypass. **UNVERIFIED**: [official project repository](https://github.com/gentilkiwi/mimikatz).

### 68. Rubeus
- **Purpose / boundary:** Windows Kerberos interaction/research tool; ticket requests, extraction, and delegation operations are sensitive and can alter authentication state.
- **Mode / terminal:** Windows .NET executable. Check release provenance, hash, runtime, and version-matched help before use.
- **Example:** For ordinary domain discovery use built-in `klist`/directory queries; no ticket extraction/forging recipe is included. Lab-only operations require explicit authorization for that exact Kerberos action.
- **Interpretation/next:** A ticket/service principal observation does not prove a usable attack path; validate configuration and rights through read-only directory evidence first.
- **Troubleshooting/evidence:** Check domain context, time sync, .NET/runtime, privileges, and policy; redact ticket material. **UNVERIFIED**: [upstream repository](https://github.com/GhostPack/Rubeus).
