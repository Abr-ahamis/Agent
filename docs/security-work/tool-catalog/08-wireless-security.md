# 08 — Wireless and network security

Wireless testing is limited to networks and devices explicitly owned or authorized. Radio capture may collect bystander data; minimize duration, channel scope, and retained packets. Injection, deauthentication, and password auditing are separate high-impact actions requiring explicit approval.

### 78. Aircrack-ng
- **Purpose / boundary:** Suite for wireless capture/analysis and authorized lab key-strength assessment; some modes inject frames or test credentials.
- **Mode / terminal:** CLI suite (`airmon-ng`, `airodump-ng`, `aireplay-ng`, `aircrack-ng`). Check each executable's `--help`/version and compatible adapter/driver.
- **Example:** Analyze a supplied synthetic/lab capture offline using the installed tool's read-only inspection options; do not provide a capture/cracking recipe for third-party networks.
- **Interpretation/next:** Capture metadata indicates observed frames, not ownership or permission. Key recovery results apply only to tested material; recommend stronger configuration rather than reusing keys.
- **Troubleshooting/evidence:** Check adapter monitor support, channel, driver, regulatory settings, and capture integrity. **UNVERIFIED**: [Aircrack-ng docs](https://www.aircrack-ng.org/documentation.html).

### 79. Kismet
- **Purpose / boundary:** Wireless discovery, monitoring, and sensor platform; passive monitoring still collects device identifiers and needs privacy authorization.
- **Mode / terminal:** Server/client hybrid with web UI and CLI tools. Check `command -v kismet kismet_cap_linux_wifi; kismet --version; kismet --help`; inspect sensor/plugin setup.
- **Example:** In a lab, use a compatible capture interface and a bounded channel/sensor configuration; use documented server logs/API for headless operation rather than claiming web UI interaction.
- **Interpretation/next:** SSIDs/BSSIDs/channel/client observations are time/location-specific; validate network ownership before any follow-up.
- **Troubleshooting/evidence:** Check capture helper permissions, driver, channel hopping, database, and web/API bind address. Retain minimal redacted data. **UNVERIFIED**: [Kismet docs](https://www.kismetwireless.net/docs/).

### 80. Bettercap
- **Purpose / boundary:** Modular network analysis and active testing framework; modules can sniff, spoof, or alter traffic.
- **Mode / terminal:** CLI/TUI/API. Check `command -v bettercap; bettercap -version; bettercap -h`; inspect module help and config before enabling.
- **Example:** Use only passive discovery in an isolated authorized lab with a named interface and output file; do not enable spoofing/poisoning modules without explicit approval.
- **Interpretation/next:** Observed hosts/protocols depend on segment visibility; active module output requires independent validation and state review.
- **Troubleshooting/evidence:** Check capabilities, interface, module dependencies, and terminal/API configuration. Stop on unexpected traffic. **UNVERIFIED**: [Bettercap docs](https://www.bettercap.org/).

### 81. hcxtools
- **Purpose / boundary:** Utilities for converting/analyzing wireless capture formats for lab auditing; associated workflows can expose authentication material.
- **Mode / terminal:** CLI tools. Check individual executable names, `--help`, version, file format, and provenance; suite commands differ by release.
- **Example:** Inspect or convert a supplied authorized lab capture using a documented conversion path; do not capture or crack third-party credentials.
- **Interpretation/next:** Conversion success means data was parsed, not that credentials are valid or a network is vulnerable. Securely dispose of sensitive capture material.
- **Troubleshooting/evidence:** Check capture format, timestamps, dependencies, and version compatibility. **UNVERIFIED**: [hcxtools repository](https://github.com/ZerBea/hcxtools).
