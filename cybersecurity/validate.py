"""CLI corpus validation; performs no security tool or network operations."""
import argparse
from pathlib import Path
from .router import SkillRouter
from .tools import ToolRegistry


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skills", type=Path, default=Path("docs/security-work/skills"))
    parser.add_argument("--tools", type=Path, default=Path("docs/security-work/tools.json"))
    args = parser.parse_args()
    router = SkillRouter(args.skills)
    registry = ToolRegistry(args.tools)
    known = set(router.skills)
    unmapped = sorted({skill for item in registry.tools.values() for skill in item["skills"] if skill not in known})
    if unmapped:
        parser.error("tool entries reference unknown skills: " + ", ".join(unmapped))
    print(f"PASS {len(router.skills)} skills; {len(registry.tools)} tool records; references resolve; skill mappings valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
