# Tool usage guide

Use the [100-tool catalog](../tool-catalog/README.md) as a decision aid, not a command checklist. Search for the relevant entry before unfamiliar or consequential use; check installed executable, version, help/manual, required data/config, identity, and GUI/API prerequisites. If current syntax or behavior remains uncertain, consult upstream documentation for that exact release. Missing capability is a limitation to report, never a result to invent.

## Terminal-first selection

1. Prefer the tool's native CLI when supported and present.
2. Use documented headless mode/API/automation where the edition and version support it.
3. Use a protocol-level CLI alternative for the specific question. `curl`/HTTPie issue requests; mitmproxy/mitmdump capture and replay proxied traffic; ZAP has API/daemon and Automation Framework modes. These do not reproduce all Burp/Caido browser interception, GUI workflows, extensions, or commercial scanner behavior.
4. If needed, write a small reviewable script using an installed protocol library. Restrict inputs, bound time/retries, avoid secrets in source/logs, and test on fixtures/lab first.
5. If a GUI-only step remains, specify the human action and export artifact needed. Do not claim GUI interaction without actual GUI capability.

For each operation, capture a question, why the method fits, exact scoped inputs, expected output, actual output, interpretation, limits, and next justified action. Preserve tool version and redacted command. Avoid indiscriminate scanner runs. Per-tool source and status labels are in each catalog entry; no examples are reported as lab-tested unless evidence is recorded.
