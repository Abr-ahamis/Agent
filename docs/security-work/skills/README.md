# Cybersecurity skill corpus

Each `SKILL.md` has JSON front matter and a practical methodology body. The standard-library loader validates metadata and required sections. Keep skills focused; reference shared deep guidance instead of copying it. Routing currently uses explicit trigger matching and transparent scores, not semantic inference.

## Skills

| Skill | Primary use |
|---|---|
| [ctf-web](ctf-web/SKILL.md) | Isolated web/API challenges |
| [binary-analysis](binary-analysis/SKILL.md) | ELF/PE triage, reversing, lab exploitation |
| [crypto-forensics](crypto-forensics/SKILL.md) | Crypto, forensics, stego, OSINT, network and misc CTFs |
| [bug-bounty-web-api](bug-bounty-web-api/SKILL.md) | Scoped web/API bounty methodology |
| [network-assessment](network-assessment/SKILL.md) | Network/infrastructure discovery |
| [active-directory](active-directory/SKILL.md) | AD enumeration and relationship analysis |
| [linux-assessment](linux-assessment/SKILL.md) | Linux host and privilege-boundary review |
| [windows-assessment](windows-assessment/SKILL.md) | Windows host and privilege-boundary review |
| [finding-validation](finding-validation/SKILL.md) | Applicability, false-positive reduction, reporting |

## Loader and selection contract

```python
from pathlib import Path
from cybersecurity import SkillRouter

router = SkillRouter(Path("docs/security-work/skills"))
plan = router.plan("Assess an authorized AD domain", environment="Windows domain", available_tools={"ldapsearch"})
```

`refresh()` rescans and rejects malformed metadata or duplicate names. `select()` returns ranked skill content, matched triggers, rationale, prerequisites, tool names, and reference paths. `plan()` reports tool availability only from the caller-supplied installed set; unmentioned tools are `availability_unknown`. A host adapter must check actual binaries/configuration and pass the result. Selection is additive via `top_k`; a host may compose specialists. If no skill meets threshold, return no match and request context/use general safety handling instead of fabricating expertise.

## Authoring a skill

1. Add a focused `domain/SKILL.md` with JSON front matter fields `name`, `description`, `domain`, `subdomains`, `triggers`, `excludes`, `prerequisites`, `tools`, and `references`.
2. Include `## Methodology`, `## Decision`, `## Verification`, `## Safety`, and `## Evidence`. Give alternatives, interpretation, failure branches, stop conditions, and references.
3. Keep commands bounded and distinguish passive/read-only from active operations. Add tools to [`tools.json`](../tools.json) with all required fields.
4. Add mocked router/policy scenarios in `tests/test_cybersecurity.py`; run `python3 -m unittest discover -s tests`.
5. Run `python3 -m cybersecurity.validate` to validate index metadata, references, tool records and skill mappings. Never use live targets as test fixtures.

## Tools, workflows, and execution boundary

The tool registry records purpose, operating systems, requirements, use cases, inputs, example, output, interpretation, limitations, alternatives, skill mappings, and operation mode. `ToolRegistry.recommend()` labels tools installed/missing/configuration-required only from caller-provided facts; it never probes or installs tools. Extend the [workflow](../workflows/README.md) and link focused decisions from skills.

`cybersecurity.policy.authorize()` is a fail-closed primitive for a host adapter to call immediately before each active operation. It checks authorization source, explicit targets, action allowlist, exclusions, and separate high-impact permission. It is not a scope parser, identity verifier, egress control, or substitute for host policy. Integration must canonicalize targets, bind policy to the actual operation, enforce rates/stop conditions, and fail closed when checks cannot be applied. It grants no real-world authorization.
