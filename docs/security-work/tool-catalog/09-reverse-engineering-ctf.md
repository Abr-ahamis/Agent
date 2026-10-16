# 09 — Reverse engineering, binary exploitation, and CTFs

Use only binaries and systems supplied for an authorized task. Prefer static inspection and disposable sandboxes for unknown programs. A crash, decompiler output, or fuzzer finding is a lead that requires reproduction and impact analysis.

### 82. Ghidra
- **Purpose / boundary:** Static reverse-engineering suite with disassembly/decompilation and extension APIs; analysis output is heuristic.
- **Mode / terminal:** GUI plus documented headless analyzer. Check release `support/analyzeHeadless` path, Java runtime, and `-help`; do not invent installation paths.
- **Example:** Run the installed `analyzeHeadless` help first, then analyze a supplied binary into a dedicated project with a reviewed script; GUI review remains needed for many interactive tasks.
- **Interpretation/next:** Decompiler pseudocode is an interpretation, not source truth; compare assembly, strings, references, and dynamic behavior in a sandbox.
- **Troubleshooting/evidence:** Check JDK, architecture, project lock, processor spec, and script compatibility. Save project/version/hash. **UNVERIFIED**: [Ghidra project docs](https://github.com/NationalSecurityAgency/ghidra).

### 83. radare2
- **Purpose / boundary:** CLI reverse-engineering framework for binary inspection/debugging; command language and plugins vary by release.
- **Mode / terminal:** CLI. Check `command -v r2; r2 -v; r2 -h`; use `?`/local help for commands.
- **Example:** Open a supplied binary read-only and use basic info/strings/disassembly commands after checking local help; avoid write mode or execution outside a sandbox.
- **Interpretation/next:** Analysis flags/functions are heuristic; validate control flow and references, then use debugger/tests for hypotheses.
- **Troubleshooting/evidence:** Check architecture, file format, plugin, analysis mode, and command syntax. **UNVERIFIED**: [radare2 book](https://book.rada.re/).

### 84. GDB
- **Purpose / boundary:** Native debugger for local processes/core files; debugging changes process state and can execute target code.
- **Mode / terminal:** CLI/TUI. Check `gdb --version; gdb --help`; verify target architecture, symbols, and ptrace permissions.
- **Example:** For a supplied lab binary, use `gdb --args <LAB_BINARY> <SAFE_ARGS>` in a disposable environment; start with `file`, `info files`, and breakpoints from the local manual.
- **Interpretation/next:** Register/stack/backtrace snapshots establish one execution path, not all behavior. Reproduce with symbols/build config and document input/state.
- **Troubleshooting/evidence:** Check ASLR/core policy, missing symbols, architecture, and sandbox. **UNVERIFIED**: [GDB manual](https://sourceware.org/gdb/current/onlinedocs/gdb/).

### 85. pwndbg
- **Purpose / boundary:** GDB plugin adding exploit-development context; it is not a separate debugger and may alter display/commands.
- **Mode / terminal:** GDB extension. Check GDB startup, `pwndbg` command availability, and version-matched installation docs; do not reinstall system GDB casually.
- **Example:** In an authorized local CTF binary, launch GDB and use documented context/register/heap commands from `help`; verify output against GDB state.
- **Interpretation/next:** Convenience annotations depend on architecture/debug symbols and plugin support; raw GDB remains source of truth.
- **Troubleshooting/evidence:** Check Python/GDB compatibility, init file ordering, and plugin version. **UNVERIFIED**: [pwndbg docs](https://pwndbg.re/).

### 86. pwntools
- **Purpose / boundary:** Python library for CTF binary interaction, packing, ELF inspection, and exploit prototypes; scripts can send network traffic or execute payloads.
- **Mode / terminal:** Python library/CLI tools. Check `python -c 'import pwn; print(pwn.__version__)'` only in an existing env and `pwn --help` if present.
- **Example:** Build a local-only parser/test harness for `<LAB_BINARY>` and assert expected behavior; for remote tubes use only a designated lab endpoint.
- **Interpretation/next:** Script success is limited to tested binary/libc/architecture; validate mitigations and reproduce in clean lab. **UNVERIFIED**: [pwntools docs](https://docs.pwntools.com/).
- **Troubleshooting/evidence:** Check virtualenv, assembler/toolchain, libc, architecture, and tube timeout. Save source, versions, input, and output.

### 87. angr
- **Purpose / boundary:** Python symbolic execution/analysis framework; path explosion, models, and environment assumptions limit conclusions.
- **Mode / terminal:** Python library. Check import/version in the chosen environment and upstream API docs; dependencies can be heavy.
- **Example:** Analyze a supplied CTF binary with a small, explicit symbolic input/state and bounded exploration; do not treat `found` as a real-world exploit.
- **Interpretation/next:** A found state is a model-satisfying path under the modeled environment; validate concrete input in a sandbox and check constraints.
- **Troubleshooting/evidence:** Check unsupported architecture, loader, solver, memory/time limits, and unconstrained state. **UNVERIFIED**: [angr docs](https://docs.angr.io/).

### 88. checksec
- **Purpose / boundary:** Reports selected binary hardening properties; exact output depends on implementation (GCC plugin, shell script, pwntools command).
- **Mode / terminal:** CLI. Check `command -v checksec; checksec --version; checksec --help` and identify source.
- **Example:** Run on a supplied binary and save output; do not infer exploitability solely from a missing mitigation.
- **Interpretation/next:** NX/PIE/canary/RELRO/fortify status are build characteristics; verify architecture, dynamic loader, and runtime settings with other tools.
- **Troubleshooting/evidence:** Check format support, symbols, executable path, and variant-specific options. **UNVERIFIED**: [slimm609/checksec](https://github.com/slimm609/checksec).

### 89. AFL++
- **Purpose / boundary:** Coverage-guided fuzzer for instrumented targets; fuzzing may consume resources and produce crashes or corrupted artifacts.
- **Mode / terminal:** CLI toolchain. Check `afl-fuzz -h; afl-clang-fast --version` and build/instrumentation docs.
- **Example:** Fuzz only a local harness and supplied test corpus in a bounded disposable directory with explicit time/CPU/disk limits; no network targets by default.
- **Interpretation/next:** Crashes are inputs needing deduplication and minimized reproduction; they do not establish remote vulnerability. Reproduce with debugger and sanitizer.
- **Troubleshooting/evidence:** Check instrumentation, seed corpus, resource limits, forkserver, and sanitizer mismatch. **UNVERIFIED**: [AFL++ docs](https://aflplus.plus/docs/).

### 90. Frida
- **Purpose / boundary:** Dynamic instrumentation toolkit for authorized app/process analysis; injected scripts can alter behavior and expose secrets.
- **Mode / terminal:** CLI plus Python API/GUI ecosystem. Check `frida --version; frida --help; python -c 'import frida'` in current env; target OS/permissions matter.
- **Example:** Attach only to a local test app/process and use a reviewed read-only tracing script; no bypass/injection on third-party apps without explicit authorization.
- **Interpretation/next:** Hooks observe selected execution points, not complete behavior. Correlate with static analysis and application logs.
- **Troubleshooting/evidence:** Check client/server version match, device authorization, architecture, and OS restrictions. **UNVERIFIED**: [Frida docs](https://frida.re/docs/).

### 91. JADX
- **Purpose / boundary:** Android APK/DEX decompiler and resource viewer; output is reconstructed Java-like code and may be incomplete.
- **Mode / terminal:** GUI and CLI launcher. Check `command -v jadx; jadx --version; jadx --help`; Java runtime needed.
- **Example:** Use CLI export on a supplied APK into a new analysis directory; inspect manifest/resources and compare critical methods with smali when conclusions matter.
- **Interpretation/next:** Decompiled code can be misleading with obfuscation/native methods; static secrets require authorization and safe redaction.
- **Troubleshooting/evidence:** Check APK validity, heap, Java version, multi-dex, and decompiler errors. **UNVERIFIED**: [JADX docs](https://github.com/skylot/jadx).

### 92. Apktool
- **Purpose / boundary:** Android APK resource decoding/rebuilding and smali inspection; rebuilding may change signatures/behavior.
- **Mode / terminal:** CLI Java tool. Check `apktool --version; apktool --help; java -version`.
- **Example:** Decode a supplied lab APK into a fresh output directory using documented `d` mode; preserve original hash and do not install modified APK outside an emulator/lab.
- **Interpretation/next:** Decoded resources are not original source and rebuild success is not functional equivalence. Verify changes in controlled emulator.
- **Troubleshooting/evidence:** Check framework resources, Java runtime, file permissions, and signing; **UNVERIFIED**: [Apktool docs](https://apktool.org/docs/).
