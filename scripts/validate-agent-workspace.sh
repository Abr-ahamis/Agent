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
