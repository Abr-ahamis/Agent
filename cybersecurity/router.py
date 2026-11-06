"""Discover Markdown skills, validate metadata, and rank/combine relevant skills."""
from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any


class SkillFormatError(ValueError):
    """A skill is missing or contains invalid metadata/content."""


@dataclass(frozen=True)
class Skill:
    name: str
    description: str
    domain: str
    subdomains: tuple[str, ...]
    triggers: tuple[str, ...]
    excludes: tuple[str, ...]
    prerequisites: tuple[str, ...]
    tools: tuple[str, ...]
    references: tuple[str, ...]
    path: Path
    body: str
    metadata: dict[str, Any]


def load_skill(path: Path) -> Skill:
    text = path.read_text(encoding="utf-8")
    match = re.match(r"\A---\s*\n(.*?)\n---\s*\n(.*)\Z", text, re.S)
    if not match:
        raise SkillFormatError(f"{path}: expected JSON front matter delimited by ---")
    try:
        data = json.loads(match.group(1))
    except json.JSONDecodeError as exc:
        raise SkillFormatError(f"{path}: invalid JSON metadata: {exc}") from exc
    required = ("name", "description", "domain", "subdomains", "triggers", "excludes", "prerequisites", "tools", "references")
    if not isinstance(data, dict) or any(k not in data for k in required):
        raise SkillFormatError(f"{path}: metadata must define {', '.join(required)}")
    if not all(isinstance(data[k], str) and data[k].strip() for k in ("name", "description", "domain")):
        raise SkillFormatError(f"{path}: name, description, and domain must be non-empty strings")
    for key in required[3:]:
        if not isinstance(data[key], list) or any(not isinstance(v, str) or not v.strip() for v in data[key]):
            raise SkillFormatError(f"{path}: {key} must be a list of non-empty strings")
    for reference in data["references"]:
        if not (path.parent / reference).resolve().is_file():
            raise SkillFormatError(f"{path}: reference does not resolve: {reference}")
    body = match.group(2).strip()
    for heading in ("Methodology", "Decision", "Verification", "Safety", "Evidence"):
        if f"## {heading}" not in body:
            raise SkillFormatError(f"{path}: missing required section ## {heading}")
    return Skill(data["name"], data["description"], data["domain"], tuple(data["subdomains"]), tuple(data["triggers"]),
                 tuple(data["excludes"]), tuple(data["prerequisites"]), tuple(data["tools"]), tuple(data["references"]),
                 path, body, data)


class SkillRouter:
    """Keyword/evidence router. Scores are transparent heuristics, not model inference."""
    def __init__(self, skill_dir: Path | str):
        self.skill_dir = Path(skill_dir)
        self.skills: dict[str, Skill] = {}
        self.refresh()

    def refresh(self) -> None:
        loaded: dict[str, Skill] = {}
        if not self.skill_dir.is_dir():
            self.skills = {}
            return
        for path in sorted(self.skill_dir.rglob("SKILL.md")):
            skill = load_skill(path)
            if skill.name in loaded:
                raise SkillFormatError(f"duplicate skill name: {skill.name}")
            loaded[skill.name] = skill
        self.skills = loaded

    @staticmethod
    def _terms(text: str) -> set[str]:
        return set(re.findall(r"[a-z0-9][a-z0-9._+-]*", text.lower()))

    def select(self, objective: str, *, environment: str = "", top_k: int = 3, threshold: int = 2) -> list[dict[str, Any]]:
        haystack = f"{objective} {environment}".lower()
        tokens = self._terms(haystack)
        ranked = []
        for skill in self.skills.values():
            if any(ex.lower() in haystack for ex in skill.excludes):
                continue
            matched = []
            score = 0
            for trigger in skill.triggers:
                phrase = trigger.lower()
                words = self._terms(phrase)
                if phrase in haystack:
                    matched.append(trigger)
                    score += 3
                elif len(words) > 1 and words <= tokens:
                    matched.append(trigger)
                    score += 2
                elif len(words) == 1 and words <= tokens:
                    # A generic single-word clue contributes evidence but cannot route alone.
                    matched.append(trigger)
                    score += 1
            if score >= threshold:
                ranked.append((score, skill, matched))
        ranked.sort(key=lambda x: (-x[0], x[1].name))
        selected = ranked[:max(0, top_k)]
        return [{"name": s.name, "score": score, "matched_triggers": matched,
                 "reason": f"Matched {', '.join(matched)} in objective/environment.",
                 "prerequisites": list(s.prerequisites), "tools": list(s.tools),
                 "references": list(s.references), "content": s.body} for score, s, matched in selected]

    def plan(self, objective: str, *, environment: str = "", available_tools: set[str] | None = None,
             top_k: int = 3) -> dict[str, Any]:
        chosen = self.select(objective, environment=environment, top_k=top_k)
        mentioned = sorted({tool for item in chosen for tool in item["tools"]})
        available = available_tools or set()
        return {"classification": sorted({self.skills[item["name"]].domain for item in chosen}),
                "skills": chosen, "tool_candidates": mentioned,
                "tool_status": {name: ("available" if name in available else "availability_unknown") for name in mentioned},
                "authorization_required": bool(chosen),
                "next_step": "Confirm objective, environment, authorization/scope, prerequisites, and tool availability before active testing."}
