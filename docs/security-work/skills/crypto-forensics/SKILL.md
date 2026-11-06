---
{"name":"crypto-forensics","description":"Investigate CTF cryptography, digital forensics, steganography, OSINT, network capture, and scripting challenges from supplied evidence and reproducible hypotheses.","domain":"ctf","subdomains":["cryptography","forensics","steganography","OSINT","network","misc","scripting","blockchain"],"triggers":["cryptography challenge","ciphertext","pcap challenge","forensics challenge","steganography","hidden data","OSINT challenge","blockchain challenge","misc challenge","programming challenge"],"excludes":["real person's private data investigation"],"prerequisites":["Confirm challenge/lab context; preserve source artifacts and record hashes; identify file formats before transformation."],"tools":["file","xxd","exiftool","binwalk","Wireshark","CyberChef","Python","Volatility 3","Autopsy"],"references":["../../tool-catalog/09-reverse-engineering-ctf.md","../../tool-catalog/10-forensics-cloud-security.md","../../references/engagement-workflows.md"]}
---
# CTF cryptography and evidence challenges

## Methodology
1. Parse challenge wording and artifact metadata; hash originals and work on copies. Identify encoding, container, capture format, timestamps, and likely source.
2. Enumerate observations before transforms: lengths, alphabets, entropy clues, metadata, packet endpoints/protocols, file signatures, repeated blocks, and known-plaintext hints.
3. Maintain competing hypotheses. For crypto, distinguish encoding from encryption; identify algorithm/key/nonce assumptions and test transformations reproducibly. For stego, inspect metadata/structure/planes and compare extracted output signatures. For forensics, build a timeline and correlate artifacts. For pcap, filter conversations and reconstruct only challenge-relevant flows. For OSINT, use only challenge-provided personas/data and respect privacy. For blockchain, inspect local challenge contracts/transactions and chain context before testing.
4. Automate small transformations with scripts and assertions; retain intermediate hashes and avoid destructive in-place processing.

Example: `file artifact && xxd -l 64 artifact` yields format clues. Printable strings or high entropy do not identify a secret or cipher by themselves. `tshark -r capture.pcap -q -z conv,tcp` summarizes TCP conversations; follow up on relevant streams.

## Decision
- Decoding yields plausible text: validate structure/checksum/context and avoid mistaking random output for plaintext.
- Candidate key/algorithm fails: revisit encoding layers, nonce/IV, byte order, padding, key derivation, and challenge hints; record rejected hypotheses.
- No obvious stego payload: inspect dimensions/metadata/bit planes/container chunks and compare file signatures; stop broad extraction once evidence narrows the path.
- Pcap is large: summarize protocols/conversations, then inspect relevant stream/timing; do not infer application compromise from captured credentials in a challenge artifact.
- Memory/disk image: identify OS/profile/artifact types, preserve image, use read-only analysis, and corroborate timeline indicators.
- No progress: identify the specific unknown, reduce input, and test one transform or artifact source at a time.

## Verification
Reproduce from original input with a documented script/command; validate recovered data structure and challenge objective. Cross-check extracted data against independent context where possible.

## Safety
Limit OSINT to authorized challenge material. Treat forensic artifacts as untrusted and potentially sensitive; avoid contacting discovered real services or publishing personal data.

## Evidence
Record original hashes, tool versions, filters/transforms, intermediate outputs, hypothesis outcomes, timestamps/timezone assumptions, and the minimal challenge proof.
