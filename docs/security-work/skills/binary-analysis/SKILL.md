---
{"name":"binary-analysis","description":"Identify, inspect, reverse engineer, and when authorized solve ELF/PE binary challenges using staged static and controlled dynamic analysis.","domain":"binary","subdomains":["ELF","PE","reverse engineering","exploitation"],"triggers":["ELF","PE executable","binary challenge","executable","reverse engineer","buffer overflow","pwn","format string","heap corruption","Ghidra","disassembly"],"excludes":["unknown executable on production host"],"prerequisites":["Preserve original and hash it; identify whether artifact is a challenge/lab or authorized sample-analysis task; use an isolated VM/container for untrusted execution."],"tools":["file","readelf","objdump","strings","checksec","Ghidra","GDB","pwntools","Detect It Easy"],"references":["../../tool-catalog/09-reverse-engineering-ctf.md","../../references/engagement-workflows.md","../../references/authorized-exploit-validation.md"]}
---
# Executable analysis and binary exploitation

## Methodology
1. Record hash, size, file type, architecture, endianness, ABI/subsystem, and whether ELF or PE. Example: `file sample`; `readelf -h -l -s sample` (ELF), `objdump -x sample` (PE/ELF), `strings -a -n 5 sample`.
2. Check symbols/imports/exports, entry point, sections, resources, strings, relocations, and protections (`checksec --file=...` where supported). NX, PIE, ASLR, RELRO, and canary status constrain hypotheses; they do not establish a vulnerability.
3. Trace entry point to meaningful functions with Ghidra/decompiler and disassembly. Inspect input parsing, length checks, format strings, integer conversions, allocation/free ownership, API calls, and error paths.
4. Form a narrow hypothesis and reproduce with a minimal input under debugger. Record registers, stack/heap state, crash location, and input offset; distinguish crash from control-flow control.
5. For exploitation, establish primitive, offset, mitigations, address leaks, calling convention, and repeatability. Develop only in an authorized isolated challenge; test each stage and prefer robust constraints-aware solutions.

Expected outputs: ELF header gives class/machine/entry; PE headers give machine/subsystem/sections; imported APIs and strings are leads, not behavior proof. `checksec` reports mitigation state, not exploitability.

## Decision
- Static view unclear or obfuscated: compare decompiler with disassembly, inspect xrefs/imports/resources, then trace execution in an isolated debugger.
- No symbols: locate entry point, imports, strings/xrefs, function boundaries, and recognizable runtime/library patterns; avoid assuming decompiler names are ground truth.
- No crash: inspect input framing, buffering, length limits, and protocol; use controlled boundary-value inputs, not unbounded fuzzing by default.
- Crash but no control: classify fault and overwrite boundary; use debugger/cyclic patterns only on local challenge copies.
- NX/PIE/canary/ASLR present: determine leak/primitive and environment. If absent, still prove control-flow and constraints before constructing a chain.
- Suspected UAF/integer/format-string issue: verify lifetime/aliasing, signedness and conversion width, or attacker-controlled formatting with minimal reproducer.
- Tool unavailable: use alternatives in the tool registry; do not silently install.

## Verification
Re-run in a clean challenge process, confirm the intended state/flag and reproducibility, and preserve the exact input and debugger evidence. A crash, suspicious import, or static pattern alone is not confirmation.

## Safety
Do not run unknown binaries on the host. Use an isolated, disposable environment with no sensitive mounts/network unless needed and explicitly authorized. Do not deploy exploit code against third-party systems.

## Evidence
Record hash, tool versions, commands, relevant disassembly/decompiler observations, mitigation output, inputs, debugger state, successful and failed hypotheses, and environmental limits.
