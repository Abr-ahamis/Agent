# Acceptance criteria

| ID | Requirement and pass condition | Verification method | Result (pass/fail/unverified) | Evidence reference |
|---|---|---|---|---|
| AC-1 | Repository architecture and constraints documented from inspected files | Review repo tree and docs | PASS | EVIDENCE.md |
| AC-2 | Skills have validated metadata and practical modular guidance | `python3 -m cybersecurity.validate` + content review | PASS | EVIDENCE.md |
| AC-3 | Router classifies representative scenarios and composes complementary skills | Automated scenario tests (10 scenarios) | PASS | EVIDENCE.md |
| AC-4 | Tool registry handles suitability/availability and alternatives | Automated unit tests | PASS | EVIDENCE.md |
| AC-5 | Active actions are blocked without adequate scope and permission | Authorization guard tests | PASS | EVIDENCE.md |
| AC-6 | Documentation explains structure, routing, authoring, tools, workflows, and extension | Documentation/link review | PASS | EVIDENCE.md |
| AC-7 | Existing catalog remains structurally valid | `bash scripts/validate-tool-catalog.sh` | PASS | EVIDENCE.md |
