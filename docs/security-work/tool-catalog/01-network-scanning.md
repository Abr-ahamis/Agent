# 01 — Network scanning and enumeration

All remote examples require an explicitly authorized target and conservative rate limits. TCP/UDP scan results describe observations from one vantage point and time; firewalls, packet loss, source filtering, and protocol behavior constrain coverage. Use a distinct evidence directory and never broaden a target range based on a tool's output alone.

### 01. Nmap
- **Purpose / boundary:** Port discovery, service/version probing, OS hints, and NSE checks; not proof of patch status or exploitability. Useful in lab, inventory, and scoped assessment.
- **Mode / terminal:** CLI; optional Zenmap GUI is not required. Check `command -v nmap; nmap --version; nmap --help`. Packet scan types may need elevated capabilities; do not elevate by default.
- **Scoped example:** `nmap -sV -p <AUTHORIZED_PORTS> -oA <OUTPUT_BASENAME> <AUTHORIZED_TARGET>`. Use `-sU` only when UDP is in scope; select explicit ports/rates and confirm exclusions before NSE.
- **Output / next:** Port states include open, closed, filtered, and ambiguous states. `-sV` is probe-derived identity; a service name based on port mapping is weaker. XML/normal/grepable outputs from `-oA` support review; follow open ports with service-specific checks and CVE applicability research.
- **Troubleshooting / evidence:** Check routing, firewall, DNS, privileges, timing, and whether the scan completed; filtered is not closed. Preserve command, version, scope, output, vantage point, and coverage limitations. **DOCUMENTED**: [Reference Guide](https://nmap.org/book/toc.html), [version detection](https://nmap.org/book/man-version-detection.html), [output](https://nmap.org/book/man-output.html); `-sV` and `-oA` checked against upstream docs, not executed.

### 02. RustScan
- **Purpose / boundary:** Fast TCP port discovery that commonly hands findings to Nmap; it is not a replacement for careful service identification.
- **Mode / terminal:** CLI. Check `command -v rustscan; rustscan --version; rustscan --help`; confirm installed release and its Nmap integration before use.
- **Scoped example:** `rustscan -a <AUTHORIZED_TARGET> --range <PORT_RANGE> -- -sV -oN <OUTPUT_FILE>` is version-sensitive; verify option spelling in local help and restrict concurrency/ports before running.
- **Output / next:** Treat reported ports as candidates, then use Nmap or a protocol client for confirmation. Missing ports can reflect rate limits, host filtering, or a truncated handoff.
- **Troubleshooting / evidence:** Check target syntax, Nmap availability, timeout/concurrency behavior, and output destination. Save version, exact command, discovered ports, handoff results, and limitations. **UNVERIFIED**: check [upstream repository](https://github.com/bee-san/RustScan) and installed help; no local install or scan claimed.

### 03. Masscan
- **Purpose / boundary:** High-speed asynchronous port discovery over authorized ranges; not full TCP session validation or comprehensive fingerprinting.
- **Mode / terminal:** CLI, often requiring raw-packet privileges and interface/source configuration. Check `command -v masscan; masscan --version; masscan --help`.
- **Scoped example:** `masscan <AUTHORIZED_CIDR> -p<AUTHORIZED_PORTS> --rate <APPROVED_LOW_RATE> -oJ <OUTPUT_FILE>`; review the installed help, interface, source address, and rate first. Avoid broad defaults.
- **Output / next:** JSON/list output indicates responses matching the scanner's probe; validate each candidate with a slower, stateful service tool such as Nmap. It can miss filtered/rate-limited ports and report transient observations.
- **Troubleshooting / evidence:** Check route/interface, privileges, packet drops, rate, and output validity. Record exact target range and rate. **UNVERIFIED** for syntax against current local help: [upstream README](https://github.com/robertdavidgraham/masscan).

### 04. Naabu
- **Purpose / boundary:** ProjectDiscovery CLI for scoped port discovery and pipeline integration; not a standalone vulnerability verdict.
- **Mode / terminal:** CLI. Check `command -v naabu; naabu -version; naabu -h`; inspect config, resolver, and rate settings for the installed release.
- **Scoped example:** `naabu -host <AUTHORIZED_HOST> -p <AUTHORIZED_PORTS> -rate <APPROVED_RATE> -o <OUTPUT_FILE>`; confirm flags locally because releases evolve. Pipe only known in-scope inputs.
- **Output / next:** Host:port results identify candidates; feed them to Nmap `-sV` or a protocol-aware client for richer evidence. Empty output is not proof of no services.
- **Troubleshooting / evidence:** Check host resolution, permissions, network path, rate limits, and stdin parsing. Save input list, version, output, and exclusions. **UNVERIFIED**: [upstream documentation](https://github.com/projectdiscovery/naabu).

### 05. Netcat
- **Purpose / boundary:** Simple TCP/UDP client/server and byte-stream diagnostic; implementations (`nc`, OpenBSD netcat, Ncat, BusyBox) differ and it does not itself identify vulnerabilities.
- **Mode / terminal:** CLI. Check `command -v nc; nc -h` and identify implementation/package. Use Ncat's own help if that is the installed executable.
- **Scoped example:** `nc -nv -w 3 <AUTHORIZED_HOST> <PORT>` tests a TCP connection; do not send arbitrary payloads. A protocol-specific harmless request is appropriate only when understood and authorized.
- **Output / next:** Connection success establishes reachability from this host, not valid authentication or authorization. Refusal, timeout, and DNS errors imply different conditions; corroborate with service probes.
- **Troubleshooting / evidence:** Check implementation-specific flags, routes, firewall, and timeout. Capture command, stderr, timestamp, and source vantage. **UNVERIFIED** until local implementation help is checked; see [Ncat manual](https://nmap.org/book/ncat-man.html) for one distinct implementation, not all netcat variants.

### 06. Socat
- **Purpose / boundary:** Flexible bidirectional data relay between sockets, files, and process endpoints; can expose or forward services, so relay/listener modes are operationally sensitive.
- **Mode / terminal:** CLI. Check `command -v socat; socat -V; man socat` where available.
- **Scoped example:** For a safe connection diagnostic use a documented address pair only after confirming the local version; do not create listeners, tunnels, or relays without explicit authorization and a defined bind address.
- **Output / next:** Verbose diagnostics describe address setup and transfer; they do not establish application correctness. A failure may be local address syntax, TLS, routing, or access control.
- **Troubleshooting / evidence:** Consult `man socat` for address types and escaping, check whether a process is listening, and preserve redacted logs. **UNVERIFIED** until local manual/version checked: [upstream project](http://www.dest-unreach.org/socat/).

### 07. Wireshark
- **Purpose / boundary:** Protocol analysis of packet captures; GUI Wireshark supports visual exploration, while TShark supplies terminal capture/dissection. Neither decrypts traffic without appropriate keys/context.
- **Mode / terminal:** Hybrid GUI/CLI. Check `command -v wireshark tshark dumpcap; tshark --version; tshark -h`. GUI requires a desktop session; Codex terminal access does not imply GUI control.
- **Scoped example:** Analyze an authorized capture with `tshark -r <INPUT_FILE> -Y '<DISPLAY_FILTER>' -T fields -e frame.number -e ip.src -e ip.dst -w <OUTPUT_FILE>`; check output/field and filter syntax in local help. Capture live traffic only with permission.
- **Output / next:** Display filters select decoded packets; capture filters act earlier and can omit traffic. Validate timestamps, interfaces, dropped-packet counters, and protocol decode. Use TCP stream/field analysis to focus a protocol-specific investigation.
- **Troubleshooting / evidence:** Check capture permissions, interface availability, dissector support, filter errors, and key-log configuration. Preserve original capture hash and a redacted export. **PARTIALLY_VERIFIED**: [Wireshark man pages](https://www.wireshark.org/docs/man-pages/) and [User's Guide](https://www.wireshark.org/docs/wsug_html/) document terminal-oriented TShark; the sample field/filter command still requires local version checking.

### 08. tcpdump
- **Purpose / boundary:** CLI packet capture/filtering for troubleshooting and evidence acquisition; it does not provide Wireshark's interactive protocol analysis.
- **Mode / terminal:** CLI. Check `command -v tcpdump; tcpdump --version; tcpdump --help` or `man tcpdump`; capture privileges are platform-specific.
- **Scoped example:** `tcpdump -i <AUTHORIZED_INTERFACE> -nn -c <PACKET_LIMIT> -w <OUTPUT_FILE> '<CAPTURE_FILTER>'`; review filter and avoid collecting unrelated traffic. Prefer bounded duration/count and a protected output path.
- **Output / next:** Live text is a decoded summary; `-w` writes packet records for later analysis. Zero packets may mean wrong interface/filter, not absent traffic. Inspect capture counters and apply a separate display filter in TShark/Wireshark.
- **Troubleshooting / evidence:** Check interface list, filter compilation, permissions, disk space, and dropped packets. Preserve capture hash, filter, interface, time, and privacy controls. **UNVERIFIED**: [tcpdump manual](https://www.tcpdump.org/manpages/tcpdump.1.html).

### 09. BIND `dig`
- **Purpose / boundary:** DNS query client for record and resolver behavior; it does not enumerate all names or prove DNS ownership.
- **Mode / terminal:** CLI, often distributed with BIND utilities. Check `command -v dig; dig -v; dig -h`.
- **Scoped example:** `dig @<AUTHORIZED_RESOLVER> <AUTHORIZED_NAME> A +noall +answer`; select record type and resolver deliberately. AXFR tests are intrusive and require explicit authorization.
- **Output / next:** Status (`NOERROR`, `NXDOMAIN`, `SERVFAIL`, etc.), flags, answer, authority, and TTL describe this resolver response. Compare authoritative and recursive answers when permitted; follow relevant SRV/MX/NS records only within scope.
- **Troubleshooting / evidence:** Check resolver reachability, DNSSEC/EDNS behavior, TCP fallback, spelling, and cache/TTL. Save query, server, timestamp, and full response. **UNVERIFIED**: [BIND 9 `dig` manual](https://bind9.readthedocs.io/en/latest/manpages.html#dig-dns-lookup-utility).

### 10. Traceroute
- **Purpose / boundary:** Estimates network path using TTL-limited probes; it does not prove full routing topology or service reachability.
- **Mode / terminal:** CLI; implementations vary (`traceroute`, `tracepath`, Windows `tracert`). Check `command -v traceroute tracepath; traceroute --help; man traceroute`.
- **Scoped example:** `traceroute -m <HOP_LIMIT> -w <SECONDS> <AUTHORIZED_HOST>` only after verifying local implementation syntax. Use TCP/ICMP modes only as needed and permitted.
- **Output / next:** Hop addresses and round-trip times are replies to probes; `*` means no qualifying reply, not necessarily a broken route. Compare protocol/method and resolve names cautiously; correlate with routing and service tests.
- **Troubleshooting / evidence:** Check ICMP filtering, asymmetric paths, VPNs, DNS, and implementation differences. Save method, source network, time, and gaps. **UNVERIFIED** until local man page checked; see the [Linux traceroute manual](https://man7.org/linux/man-pages/man8/traceroute.8.html) and use the target OS's manual for other implementations.
