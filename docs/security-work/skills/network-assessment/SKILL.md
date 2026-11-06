---
{"name":"network-assessment","description":"Conduct scoped network discovery and service-directed enumeration, interpreting uncertainty and routing protocols to focused specialists.","domain":"network","subdomains":["discovery","TCP/UDP","protocols","segmentation"],"triggers":["network penetration test","network scan","port scan","service enumeration","infrastructure assessment","SMB service","SNMP assessment","firewall assessment"],"excludes":["public IP without authorization","denial of service"],"prerequisites":["Confirm written target ranges, exclusions, vantage, time window, allowed probes, rate limits, and emergency stop contact."],"tools":["Nmap","RustScan","Netcat","Wireshark","Tshark","Tcpdump","Nuclei","WhatWeb","testssl.sh","dig"],"references":["../../references/scope-and-authorization.md","../../references/network-service-enumeration.md","../../tool-catalog/01-network-scanning.md","../../tool-catalog/02-osint-dns-recon.md"]}
---
# Network and infrastructure assessment

## Methodology
1. Normalize exact CIDRs/hosts and resolve scope ambiguities with owner. Record vantage, time, rate, protocol, exclusions, and tool versions.
2. Establish reachability with minimal probes. Use `dig`/`nslookup` for scoped DNS context; Nmap targeted TCP discovery/service detection; RustScan/Naabu only for bounded candidate discovery followed by confirmation. UDP silence is often `open|filtered`.
3. For each confirmed service, record transport, state, evidence confidence, TLS/authentication, observed banner, and next service-specific question. Banner/version does not prove patch level.
4. Route HTTP to web/API skill; SMB/LDAP/Kerberos/domain clues to AD; host access to Linux/Windows local assessment. Review firewall/segmentation only from approved source/destination pairs.
5. Capture packets with tcpdump/Tshark/Wireshark only when needed; filter narrowly and protect sensitive captures. Nuclei templates require scope and review; findings are leads, not proof.

Service questions: SSH algorithms/auth methods; FTP vs FTPS/SFTP and anonymous policy; DNS records/authoritative context; SMTP TLS/extensions; SMB dialect/signing/guest/share metadata; RDP NLA/TLS; WinRM interface/auth; LDAP naming context/TLS; SNMP version/read model; database TLS/auth and minimum metadata; NFS exports. No login or data access follows from an open port.

## Decision
- No host response: verify local routing/vantage and target spelling; distinguish filtered, unreachable, closed, and timeout. Ask owner before increasing probes or changing vantage.
- Ports absent: check protocol (TCP/UDP), approved range, filtering, and known service ports with a targeted probe. Do not claim complete coverage.
- Banner unclear: use protocol-aware safe handshake and correlate independent evidence; do not jump to exploit from banner.
- Service newly reveals a host/domain: confirm it is in scope before any follow-up.
- Likely CVE: verify exact package/build, vendor backports, configuration and prerequisites using advisories; use dedicated validation workflow.
- Instability, data exposure, or unexpected third-party routing: stop immediately.

## Verification
Confirm candidate ports with a second appropriate probe and preserve raw/structured scan output. Record vantage, timing, retransmission/rate, exclusions, and unresolved states. Report tested coverage, not absolute absence.

## Safety
No broad high-speed scanning, UDP sweeps, vulnerability templates, credential attempts, or stateful checks without explicit allowance. Never perform DoS or intrusive exploit validation by default.

## Evidence
Retain scope source, exact command/options, tool version, timestamps, source vantage, output, service-confidence basis, limitations, and follow-up authorization decisions.
