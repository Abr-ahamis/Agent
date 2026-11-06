"""Tool registry with availability-aware, skill-aware recommendations."""
from __future__ import annotations
import json
from pathlib import Path
from typing import Any


class ToolRegistry:
    REQUIRED = {"name", "purpose", "operating_systems", "requirements", "use_cases", "inputs", "example",
                "expected_output", "interpretation", "limitations", "alternatives", "skills", "mode"}

    def __init__(self, path: Path | str):
        data = json.loads(Path(path).read_text(encoding="utf-8"))
        if not isinstance(data, list):
            raise ValueError("tool registry must be a JSON list")
        self.tools: dict[str, dict[str, Any]] = {}
        for item in data:
            if not isinstance(item, dict) or self.REQUIRED - item.keys():
                raise ValueError("each tool entry must include all documented fields")
            name = item["name"]
            if name in self.tools:
                raise ValueError(f"duplicate tool: {name}")
            self.tools[name] = item

    def recommend(self, skills: list[str], *, installed: set[str] = frozenset(), configured: set[str] = frozenset()) -> list[dict[str, Any]]:
        result = []
        for item in self.tools.values():
            if not set(skills).intersection(item["skills"]):
                continue
            status = "installed" if item["name"] in installed else "missing"
            if item.get("configuration") and item["name"] not in configured and status == "installed":
                status = "configuration_required"
            result.append({**item, "status": status})
        return result
