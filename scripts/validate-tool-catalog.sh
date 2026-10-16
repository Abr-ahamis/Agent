#!/usr/bin/env bash
# Structural catalog check only; never executes security tools or targets.
set -Eeuo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
DRY_RUN=false
FAILURES=0
pass() { printf 'PASS %s\n' "$*"; }
fail() { printf 'FAIL %s\n' "$*"; FAILURES=$((FAILURES + 1)); }
usage() { printf 'Usage: %s [--help] [--dry-run] [--root PATH]\n' "${0##*/}"; }
while (($#)); do
  case "$1" in
    --help) usage; exit 0 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --root) (($# >= 2)) || { printf 'ERROR: --root requires PATH\n' >&2; exit 2; }; ROOT="$2"; shift 2 ;;
    --root=*) ROOT="${1#*=}"; shift ;;
    *) printf 'ERROR: unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done
[[ -d "$ROOT" ]] || { printf 'ERROR: root does not exist: %s\n' "$ROOT" >&2; exit 2; }
ROOT="$(cd -- "$ROOT" && pwd -P)"
CAT="$ROOT/docs/security-work/tool-catalog"
FILES=(01-network-scanning.md 02-osint-dns-recon.md 03-web-discovery.md 04-web-api-testing.md 05-exploitation-password-auditing.md 06-active-directory-windows.md 07-system-enumeration-privesc.md 08-wireless-security.md 09-reverse-engineering-ctf.md 10-forensics-cloud-security.md)
REFERENCES=(scope-and-authorization.md tool-usage-guide.md network-service-enumeration.md linux-enumeration.md windows-enumeration.md active-directory-enumeration.md web-application-enumeration.md post-access-enumeration.md cve-research-and-validation.md authorized-exploit-validation.md security-reporting.md engagement-workflows.md tool-research-and-maintenance.md)
EXPECTED=(
'Nmap' 'RustScan' 'Masscan' 'Naabu' 'Netcat' 'Socat' 'Wireshark' 'tcpdump' 'BIND `dig`' 'Traceroute'
'Amass' 'Subfinder' 'Assetfinder' 'DNSrecon' 'dnsx' 'Shodan' 'Censys' 'theHarvester' 'Recon-ng' 'SpiderFoot' 'Maltego' 'httpx'
'gau' 'waybackurls' 'Katana' 'ffuf' 'Gobuster' 'Feroxbuster' 'dirsearch' 'GoWitness'
'Burp Suite' 'OWASP ZAP' 'Caido' 'mitmproxy' 'Postman' 'Nuclei' 'Nikto' 'testssl.sh' 'WPScan' 'sqlmap' 'Dalfox' 'Arjun' 'jwt_tool' 'Kiterunner' 'SSRFmap' 'Commix'
'Metasploit Framework' 'SearchSploit' 'msfvenom' 'Hydra' 'John the Ripper' 'Hashcat' 'CeWL' 'SecLists'
'Impacket' 'NetExec' 'BloodHound CE' 'SharpHound' 'Certipy' 'Kerbrute' 'Responder' 'ntlmrelayx' 'enum4linux-ng' 'smbclient' 'ldapsearch' 'Evil-WinRM' 'Mimikatz' 'Rubeus'
'LinPEAS' 'WinPEAS' 'pspy' 'Linux Exploit Suggester' 'GTFOBins' 'Seatbelt' 'PowerView' 'Sysinternals Suite' 'Autoruns'
'Aircrack-ng' 'Kismet' 'Bettercap' 'hcxtools'
'Ghidra' 'radare2' 'GDB' 'pwndbg' 'pwntools' 'angr' 'checksec' 'AFL++' 'Frida' 'JADX' 'Apktool'
'Volatility 3' 'Autopsy' 'YARA' 'Binwalk' 'CyberChef' 'RsaCtfTool' 'Trivy' 'Prowler')
if [[ "$DRY_RUN" == true ]]; then
  printf 'DRY-RUN: would check inventory, unique entries, required tool fields, links, terminal alternatives, and Bash syntax. No security tools run.\n'
  exit 0
fi
[[ -d "$CAT" ]] && pass 'catalog directory exists' || fail 'missing catalog directory'
for file in README.md "${FILES[@]}"; do
  if [[ -s "$CAT/$file" ]]; then pass "file exists: $file"; else fail "missing/empty file: $file"; fi
done
count=0
if [[ -d "$CAT" ]]; then count="$(grep -hEc '^### ([0-9]{2}|100)\. ' "$CAT"/*.md 2>/dev/null | awk -F: '{n+=$NF} END {print n+0}')"; fi
if [[ "$count" == 100 ]]; then pass 'exactly 100 numbered entries' ; else fail "expected 100 numbered entries, found $count"; fi
for i in "${!EXPECTED[@]}"; do
  id=$(printf '%02d' "$((i + 1))")
  heading="### $id. ${EXPECTED[$i]}"
  hits=0
  if [[ -d "$CAT" ]]; then hits="$(grep -hFxc "$heading" "$CAT"/*.md 2>/dev/null | awk '{n+=$1} END {print n+0}')"; fi
  if [[ "$hits" != 1 ]]; then fail "entry $id ${EXPECTED[$i]} occurs $hits times"; continue; fi
  pass "entry $id ${EXPECTED[$i]} exists once"
  block="$(awk -v h="$heading" 'BEGIN{p=0} $0==h{p=1;print;next} /^### ([0-9][0-9]|100)\. /{if(p)exit} p{print}' "$CAT"/*.md 2>/dev/null || true)"
  [[ "$block" == *'**Purpose'* && "$block" == *'**Mode'* ]] && pass "$id purpose/mode" || fail "$id missing purpose/mode"
  [[ "$block" == *'example'* || "$block" == *'Example'* ]] && pass "$id example" || fail "$id missing example"
  [[ "$block" == *'Interpretation'* || "$block" == *'**Output'* ]] && pass "$id output interpretation" || fail "$id missing interpretation"
  [[ "$block" == *'Troubleshooting'* ]] && pass "$id troubleshooting" || fail "$id missing troubleshooting"
  [[ "$block" == *'DOCUMENTED'* || "$block" == *'UNVERIFIED'* || "$block" == *'PARTIALLY_VERIFIED'* ]] && pass "$id verification status" || fail "$id missing status"
  [[ "$block" == *'https://'* || "$block" == *'http://'* ]] && pass "$id source link" || fail "$id missing source link"
done
if [[ -d "$CAT" ]]; then
  duplicates="$(grep -hE '^### ([0-9]{2}|100)\. ' "$CAT"/*.md | sed -E 's/^### ([0-9]{2}|100)\. //' | sort | uniq -d || true)"
  [[ -z "$duplicates" ]] && pass 'no duplicate tool names' || fail "duplicate names: $duplicates"
  duplicate_ids="$(grep -hE '^### ([0-9]{2}|100)\. ' "$CAT"/*.md | sed -E 's/^### ([0-9]{2}|100)\..*/\1/' | sort | uniq -d || true)"
  [[ -z "$duplicate_ids" ]] && pass 'no duplicate identifiers' || fail "duplicate IDs: $duplicate_ids"
fi
for file in "${FILES[@]}"; do
  if [[ -s "$CAT/README.md" && -s "$CAT/$file" ]] && grep -Fq "$file" "$CAT/README.md"; then pass "category link resolves: $file"; else fail "category link broken: $file"; fi
done
for file in "${REFERENCES[@]}"; do
  if [[ -s "$ROOT/docs/security-work/references/$file" ]]; then pass "workflow reference exists: $file"; else fail "missing workflow reference: $file"; fi
done
for term in terminal tshark mitmproxy analyzeHeadless 'Sleuth Kit'; do
  if grep -RiqF "$term" "$CAT"; then pass "terminal/GUI path mentions $term"; else fail "missing terminal/GUI path: $term"; fi
done
if bash -n "$ROOT/scripts/validate-tool-catalog.sh"; then pass 'validator syntax'; else fail 'validator syntax'; fi
if ((FAILURES)); then printf 'RESULT FAIL (%d issue(s))\n' "$FAILURES"; exit 1; fi
printf 'RESULT PASS (structure only; it does not validate every tool procedure)\n'
