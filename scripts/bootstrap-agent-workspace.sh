#!/usr/bin/env bash
# Create missing files for the reliable-work scaffold; preserve existing work.
set -Eeuo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
DRY_RUN=false
CREATED=()
SKIPPED=()
ERRORS=()
usage() { printf 'Usage: %s [--dry-run] [--root PATH] [--help]\n' "${0##*/}"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
while (($#)); do
  case "$1" in
    --help) usage; exit 0 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --root) (($# >= 2)) || die '--root requires a path'; ROOT="$2"; shift 2 ;;
    --root=*) ROOT="${1#*=}"; shift ;;
    *) die "unknown option: $1 (use --help)" ;;
  esac
done
[[ -n "$ROOT" ]] || die 'workspace root must not be empty'
if [[ ! -d "$ROOT" ]]; then
  if [[ "$DRY_RUN" == true ]]; then die "workspace root does not exist (dry run will not create it): $ROOT"; fi
  mkdir -p -- "$ROOT" || die "cannot create workspace root: $ROOT"
fi
ROOT="$(cd -- "$ROOT" && pwd -P)"
write_file() {
  local rel="$1" target="$ROOT/$1" parent
  case "$target" in "$ROOT"/*) ;; *) die "refusing path outside root: $rel" ;; esac
  if [[ -e "$target" || -L "$target" ]]; then SKIPPED+=("$rel"); printf 'PRESERVED %s\n' "$rel"; return; fi
  if [[ "$DRY_RUN" == true ]]; then CREATED+=("$rel"); printf 'WOULD CREATE %s\n' "$rel"; return; fi
  parent="$(dirname -- "$target")"
  if ! mkdir -p -- "$parent"; then
    ERRORS+=("cannot create directory: $parent")
    printf 'ERROR cannot create directory: %s\n' "$parent" >&2
    return 0
  fi
  if ! cat > "$target"; then
    ERRORS+=("cannot write file: $target")
    printf 'ERROR cannot write file: %s\n' "$target" >&2
    return 0
  fi
  CREATED+=("$rel"); printf 'CREATED %s\n' "$rel"
}
write_file AGENTS.md <<'EOF'
# Repository instructions

- Preserve the user's intent, existing work, and approved scope. Prefer minimal, reversible changes.
- For suitable multi-step, cross-domain, or risk-sensitive work, read and apply `.agents/skills/reliable-work/SKILL.md`. Keep trivial tasks proportionate.
- Use `tasks/templates/` for complex, multi-step, high-risk, or hard-to-verify work. Create a separate record under `tasks/active/`; never edit templates as task records.
- Inspect relevant state before changing it and follow task-specific requirements and platform permissions.
- Verify actual results against observable criteria. Never claim actions or checks without evidence; distinguish facts, assumptions, limitations, and unresolved work.
EOF
write_file docs/agent-workflow.md <<'EOF'
# Agent workflow

## Instruction layers
`AGENTS.md` gives repository-level guidance. `.agents/skills/reliable-work/SKILL.md` provides a reusable procedure for suitable work; it does not replace repository or task instructions. Task requirements define the requested outcome and boundaries, subject to platform rules and permissions.

Markdown conventions take effect only when the agent runtime discovers them or the agent is explicitly instructed to read them. A skill's presence or name alone does not guarantee activation.

## Normal workflow
1. Identify deliverables, scope, constraints, risk, and complexity.
2. Inspect relevant workspace, data, and environment; preserve existing changes.
3. Separate verified facts, assumptions, unknowns, and external claims.
4. Set observable acceptance criteria and choose domain-appropriate methods.
5. Plan proportionately; use task records for complex work, not trivial requests.
6. Execute manageable steps with minimal, recoverable changes.
7. Verify actual results against criteria; plans are not evidence.
8. Correct failures and recheck affected results. Report work, evidence, limits, and unresolved issues.

## Skills, tools, plans, and evidence
Skills describe reusable procedures; executable tools perform operations within permissions. A plan is not proof. Each check establishes only its stated scope. Final claims should map to observed evidence and identify incomplete work.
EOF
write_file .agents/skills/reliable-work/SKILL.md <<'EOF'
---
name: reliable-work
description: Use for multi-step, ambiguous, consequential, or verification-sensitive work across software, research, writing, cybersecurity, system administration, and data tasks; scale the process to complexity and risk.
---

# Reliable work

Use this procedure proportionately. For trivial, low-risk requests, keep it brief and avoid unnecessary task files.

1. Classify domain, complexity, risk, and deliverables; resolve material ambiguity that blocks safe or correct work.
2. Inspect relevant workspace, data, sources, and environment before acting; preserve user work.
3. Distinguish verified facts, assumptions, unknowns, and external claims. Identify constraints, permissions, and risks.
4. Define observable acceptance criteria and choose domain-appropriate tools and verification methods.
5. Plan and execute manageable steps. Use task documents for complex, multi-step, high-risk, or hard-to-verify work.
6. Verify actual results against criteria; an attempted action or plan is not evidence of success.
7. On failure, diagnose, revise safely, and recheck affected results. Report completed work, evidence, limits, and unresolved issues.

Never invent requirements, results, citations, capabilities, or completed actions. Do not claim a test ran, action succeeded, file changed, or criterion passed without evidence.

References: [task file guide](references/task-file-guide.md), [verification matrix](references/verification-matrix.md), [safety and permissions](references/safety-and-permissions.md).
EOF
write_file .agents/skills/reliable-work/references/task-file-guide.md <<'EOF'
# Task file guide

Use only documents that help control the work. Keep one source for each kind of information; link or summarize elsewhere instead of copying.

| File | Responsibility |
|---|---|
| `GOAL.md` | Intended end state, scope, constraints, and non-goals. |
| `TASK.md` | Concrete assignment, inputs, deliverables, and boundaries. |
| `ACCEPTANCE.md` | Observable completion requirements, pass conditions, verification method, and result. |
| `PLAN.md` | Ordered steps, dependencies, checkpoints, and recovery considerations. |
| `CONTEXT.md` | Relevant environment, sources of truth, tools, established facts, assumptions, and unknowns. |
| `PROGRESS.md` | Current status, completed work, next steps, blockers, and verification status. |
| `DECISIONS.md` | Significant decisions, rationale, alternatives, and consequences. |
| `EVIDENCE.md` | Actual verification results and supporting evidence. |

The goal states why and where work should end; task states what to do; acceptance says how completion is judged. Context informs the plan. Progress tracks execution, decisions explain consequential choices, and evidence records observed outcomes. Do not treat a plan as proof or duplicate full evidence in progress notes.

Simple, low-risk work may need no task records. Create a task-specific directory under `tasks/active/` for complex, multi-step, high-risk, shared-session, or hard-to-verify work. Copy only applicable templates into a new directory, fill in task facts, and leave originals untouched. Keep sensitive data out.
EOF
write_file .agents/skills/reliable-work/references/verification-matrix.md <<'EOF'
# Verification matrix

Select checks that match acceptance criteria and record their limits. Automated checks are repeatable but bounded by their scope; human review adds context but can be subjective.

| Category | Automated checks: establish / do not establish | Human judgment: establishes / does not establish |
|---|---|---|
| Programming | Tests, linters, type checks, builds, and diff checks establish covered behavior/properties in that environment; they do not prove no defects, production behavior, or untested cases. | Review requirements, edge cases, and maintainability; it assesses quality but cannot guarantee correctness. |
| Research | Metadata checks, reproducible calculations, and cross-source comparisons establish that inspected material aligns with claims; they do not prove sources truthful, complete, current, or unbiased. | Assess authority, methods, context, and qualification; judgment is not independent factual proof. |
| Writing | Spell/grammar and structure checks establish detectable mechanical properties; they do not establish accuracy, audience fit, or persuasive quality. | Review clarity, tone, completeness, and support; reviewers can miss errors. |
| Cybersecurity | Authorized lab tests and configuration checks establish observations within the authorized target and conditions; they do not prove general authorization, no vulnerabilities, or safety out of scope. | Confirm scope and permission and interpret impact; review does not substitute for authorization. |
| Linux administration | Config validation, service status, logs, and before/after checks establish observed state at that time; they do not prove long-term stability or safety under all workloads. | Review blast radius, rollback, access impact, and operational fit; this cannot replace post-change observation. |
| Data analysis | Schema/range checks, reproducible scripts, reconciliation, and recomputation establish results for supplied data and assumptions; they do not prove data accuracy, representativeness, or lack of bias. | Review assumptions, transformations, missingness, and interpretation; unavailable provenance cannot be validated. |

For each check record criterion, command/source, observed output, interpretation, and status. Correct failures and rerun affected checks. If a check cannot run, report it as unverified.
EOF
write_file .agents/skills/reliable-work/references/safety-and-permissions.md <<'EOF'
# Safety and permissions

Scale safeguards to impact. Begin with read-only inspection, make the smallest useful change, preserve recovery options, and independently verify the resulting state.

- **Destructive or irreversible operations:** Identify targets, scope, dependencies, and rollback limits. Prefer previews, backups, transactions, or reversible alternatives. Get required approval before high-impact actions; do not infer consent from a broad goal.
- **Files and uncommitted work:** Inspect status and relevant content. Preserve unrelated modifications and deletions. Do not overwrite or remove user data without authorization. Review the final diff.
- **Sensitive information and credentials:** Avoid reading, copying, logging, or recording secrets. Use approved secret handling; redact evidence and reports.
- **External communications and deployments:** Prepare and review the concrete artifact first. Obtain appropriate approval before sending, publishing, or changing a live service unless that exact action is clearly authorized.
- **Network and cybersecurity activity:** Confirm ownership or explicit authorization, scope, allowed methods, and timing. Stay within scope and platform rules; learning intent alone is not authorization.
- **Missing authorization or essential information:** Stop the dependent high-impact action. Continue safe independent preparation where useful; state what is missing and request the minimum needed clarification or approval.

This guidance grants no permission and does not override user instructions, platform policies, operating-system safeguards, or applicable law. When authority or impact is uncertain, use a safe read-only step and resolve uncertainty first.
EOF
write_file tasks/templates/GOAL.md <<'EOF'
# Goal

Describe the intended end state, scope, constraints, and non-goals. Do not turn assumptions into requirements.

## Desired state
[What should be true when complete?]

## Scope and boundaries
[Included areas, exclusions, constraints, and non-goals.]
EOF
write_file tasks/templates/TASK.md <<'EOF'
# Task

## Request
[Concrete assignment, preserving the user's intent.]

## Inputs
[Provided files, data, references, environment, and prerequisites.]

## Deliverables
[Specific expected outputs.]

## Boundaries
[Authorized actions, excluded work, and constraints.]
EOF
write_file tasks/templates/ACCEPTANCE.md <<'EOF'
# Acceptance criteria

List observable conditions; pass only when the stated verification has evidence.

| ID | Requirement and pass condition | Verification method | Result (pass/fail/unverified) | Evidence reference |
|---|---|---|---|---|
| AC-1 | [Observable condition] | [Check that can establish it] | [Status] | [EVIDENCE.md entry/source] |
EOF
write_file tasks/templates/PLAN.md <<'EOF'
# Plan

Order steps and note dependencies, checkpoints, and recovery. Update when evidence changes the approach.

1. [Step and prerequisites]
2. [Step and checkpoint]
3. [Verification step]

## Recovery
[Safe rollback, retry, or stop conditions.]
EOF
write_file tasks/templates/CONTEXT.md <<'EOF'
# Context

Record relevant facts; keep sensitive information out.

## Environment and tools
[Relevant versions, paths, capabilities, and constraints.]

## Sources of truth
[Files, data, people, or authoritative sources inspected.]

## Established facts
- [Fact and evidence/source]

## Assumptions
- [Assumption and impact]

## Unknowns
- [Unknown, impact, and resolution plan]
EOF
write_file tasks/templates/PROGRESS.md <<'EOF'
# Progress

## Status
[Not started / in progress / blocked / complete.]

## Completed work
- [Actual work and evidence pointer]

## Next steps
- [Next action]

## Blockers
- [Blocker or “None identified”]

## Verification
[Completed, failed, or outstanding checks; link to EVIDENCE.md.]
EOF
write_file tasks/templates/DECISIONS.md <<'EOF'
# Decisions

Record choices that materially shape scope, method, or outcome.

## Decision [ID or date]
- **Decision:** [Choice]
- **Reason:** [Evidence and constraints]
- **Alternatives:** [Relevant options and why not chosen]
- **Consequences:** [Tradeoffs or follow-up]
EOF
write_file tasks/templates/EVIDENCE.md <<'EOF'
# Evidence

Record observed results, not intended actions. Redact sensitive information.

| Criterion | Command or source | Observed result | Interpretation and limits | Status |
|---|---|---|---|---|
| [AC-ID] | [Exact check/source/artifact] | [What was observed] | [What it establishes and does not establish] | [Pass/fail/unverified] |
EOF
write_file tasks/active/README.md <<'EOF'
# Active task records

For work needing persistent records, create a separate descriptive directory here. Copy only applicable files from `../templates/` into the new directory and edit those copies; never overwrite the originals. Keep secrets and unnecessary personal data out. A simple task may not need a directory.
EOF
write_file tests/skill-evaluation-cases.md <<'EOF'
# Reliable-work skill evaluation cases

These are proposed review scenarios, not executed tests or proof that the skill passes.

| Scenario | Expected behavior | Reviewer evaluation |
|---|---|---|
| Simple, low-risk task | Complete directly with proportionate checks; avoid excessive planning and task files. | Confirm request is met and overhead is appropriate. |
| Multi-step coding task | Inspect, define criteria, make manageable changes, run relevant tests, and report evidence. | Confirm scope, actual test output, failure handling, and claims. |
| Research requiring reliable sources | Use appropriate authoritative/current sources, attribute claims, separate fact and inference. | Check source support, context, dates, and uncertainty. |
| Ambiguous task with material unknown | Surface the unknown and ask or use only a safe, explicit assumption. | Ensure no invented requirement is silently introduced. |
| Failed verification | Diagnose, correct safely, rerun affected checks, disclose unresolved failures. | Compare initial/final evidence and status claims. |
| Potentially destructive system operation | Inspect scope and rollback; use preview/reversible option; obtain required approval. | Confirm authorization and approval preceded high-impact action. |
| Missing tool or permission | State the gap, do safe independent work if useful, mark dependent criteria unverified. | Ensure no fabricated access or completion claim. |
| Final report with incomplete work | Tie completed claims to evidence and identify limitations/unresolved criteria. | Trace material claims to observations and verify incomplete work is explicit. |
EOF
write_file scripts/validate-agent-workspace.sh <<'EOF'
#!/usr/bin/env bash
# Validate scaffold consistency, not agent reasoning or future task correctness.
set -Eeuo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
FAILURES=0
usage() { printf 'Usage: %s [--root PATH] [--help]\n' "${0##*/}"; }
pass() { printf 'PASS %s\n' "$*"; }
fail() { printf 'FAIL %s\n' "$*"; FAILURES=$((FAILURES + 1)); }
while (($#)); do
  case "$1" in
    --help) usage; exit 0 ;;
    --root) (($# >= 2)) || { printf 'ERROR: --root requires a path\n' >&2; exit 2; }; ROOT="$2"; shift 2 ;;
    --root=*) ROOT="${1#*=}"; shift ;;
    *) printf 'ERROR: unknown option: %s\n' "$1" >&2; exit 2 ;;
  esac
done
[[ -d "$ROOT" ]] || { printf 'ERROR: root does not exist: %s\n' "$ROOT" >&2; exit 2; }
ROOT="$(cd -- "$ROOT" && pwd -P)"
DIRS=(scripts docs .agents/skills/reliable-work .agents/skills/reliable-work/references tasks/templates tasks/active tests)
FILES=(AGENTS.md scripts/bootstrap-agent-workspace.sh scripts/validate-agent-workspace.sh docs/agent-workflow.md .agents/skills/reliable-work/SKILL.md .agents/skills/reliable-work/references/task-file-guide.md .agents/skills/reliable-work/references/verification-matrix.md .agents/skills/reliable-work/references/safety-and-permissions.md tasks/templates/GOAL.md tasks/templates/TASK.md tasks/templates/ACCEPTANCE.md tasks/templates/PLAN.md tasks/templates/CONTEXT.md tasks/templates/PROGRESS.md tasks/templates/DECISIONS.md tasks/templates/EVIDENCE.md tasks/active/README.md tests/skill-evaluation-cases.md)
for path in "${DIRS[@]}"; do if [[ -d "$ROOT/$path" ]]; then pass "directory exists: $path"; else fail "missing directory: $path"; fi; done
for path in "${FILES[@]}"; do if [[ -s "$ROOT/$path" ]]; then pass "non-empty file exists: $path"; else fail "missing or empty file: $path"; fi; done
skill="$ROOT/.agents/skills/reliable-work/SKILL.md"
if [[ -s "$skill" ]]; then
  first="$(head -n 1 "$skill")"
  end="$(awk 'NR>1 && /^---[[:space:]]*$/ {print NR; exit}' "$skill")"
  name="$(sed -n '2,/^---[[:space:]]*$/s/^name:[[:space:]]*//p' "$skill" | head -n 1)"
  desc="$(sed -n '2,/^---[[:space:]]*$/s/^description:[[:space:]]*//p' "$skill" | head -n 1)"
  if [[ "$first" == '---' && -n "$end" && "$name" == reliable-work && -n "$desc" ]]; then pass 'SKILL.md basic YAML front matter'; else fail 'SKILL.md requires name: reliable-work and a description in YAML front matter'; fi
  for ref in references/task-file-guide.md references/verification-matrix.md references/safety-and-permissions.md; do
    if grep -Fq "$ref" "$skill" && [[ -s "$ROOT/.agents/skills/reliable-work/$ref" ]]; then pass "skill reference resolves: $ref"; else fail "missing or unlinked reference: $ref"; fi
  done
else fail 'cannot inspect SKILL.md front matter'; fi
if bash -n "$ROOT/scripts/bootstrap-agent-workspace.sh"; then pass 'bootstrap passes bash -n'; else fail 'bootstrap fails bash -n'; fi
if ((FAILURES)); then printf 'RESULT FAIL (%d issue(s))\n' "$FAILURES"; exit 1; fi
printf 'RESULT PASS (scaffold consistency only; not proof of agent correctness)\n'
EOF
printf '\nSummary (%s)\nCreated/planned (%d):\n' "$ROOT" "${#CREATED[@]}"
for item in "${CREATED[@]}"; do printf '  %s\n' "$item"; done
printf 'Skipped and preserved (%d):\n' "${#SKIPPED[@]}"
for item in "${SKIPPED[@]}"; do printf '  %s\n' "$item"; done
printf 'Errors (%d):\n' "${#ERRORS[@]}"
for item in "${ERRORS[@]}"; do printf '  %s\n' "$item"; done
if ((${#ERRORS[@]})); then exit 1; fi
