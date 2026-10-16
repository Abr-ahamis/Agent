# Security tool knowledge maintenance

This is the writable-workspace companion for security-work materials. The canonical 100-tool catalog is indexed in [the catalog README](security-work/tool-catalog/README.md); assessment-specific observations belong in task evidence, not here. The security skill entry point remains under `.agents/skills/security-work/` and must link this material when that path is writable.

## Research and update process

1. Name the tool/technique, the task that exposed the gap, and the exact unknown.
2. Prefer upstream manuals, official project documentation, release notes, installed help, and vendor advisories. Use secondary sources only to locate primary sources.
3. Check the applicable version, executable/mode, prerequisites, authorization, inputs, output, limits, and operational effects. Review code before running it. Never run a new command against a real target merely to verify syntax.
4. Test only in an authorized, suitable lab when useful. Record whether guidance is `DOCUMENTED`, `LOCAL_HELP_VERIFIED`, `LAB_TESTED`, `PARTIALLY_VERIFIED`, `UNVERIFIED`, or `NOT_APPLICABLE`.
5. Improve the existing entry. Record reviewed date, source URL, applicable version, result, and remaining uncertainty. Keep secrets, customer data, and target-specific findings out of reusable entries.
6. Recheck links and catalog validation. A structural pass does not validate every command or establish exploitability.

## Terminal-first use

Prefer native CLI, supported headless/API automation, then a protocol-level CLI alternative or small reviewed script. A CLI alternative does not reproduce every GUI capability. GUI-only workflows require a human with a graphical session; an agent must report that limitation instead of claiming interaction. Check installed executables and `--help`/manual pages before relying on version-sensitive options. Do not install tools or alter system settings without an appropriate reason and approval.

## Status and changelog

Catalog entries label the evidence status per procedure. The initial catalog is a researched working reference, not a claim that all 100 tools were installed or tested. Record future changes below with date, entry, reason, source, and verification status.

| Date | Entry | Change and reason | Source | Status |
|---|---|---|---|---|
| 2026-10-16 | Initial catalog | Added terminal-first entries; tool availability and lab behavior remain environment-dependent. | Per-entry upstream links | PARTIALLY_VERIFIED |
