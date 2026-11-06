import json
import tempfile
import unittest
from pathlib import Path

from cybersecurity import Action, AuthorizationError, Scope, SkillRouter, ToolRegistry, authorize
from cybersecurity.router import SkillFormatError

ROOT = Path(__file__).resolve().parents[1]
SKILLS = ROOT / "docs/security-work/skills"


class SkillRouterTests(unittest.TestCase):
    def setUp(self):
        self.router = SkillRouter(SKILLS)

    def test_discovery_and_metadata(self):
        self.assertGreaterEqual(len(self.router.skills), 8)
        self.assertIn("active-directory", self.router.skills)
        for skill in self.router.skills.values():
            self.assertTrue(skill.description)
            self.assertTrue(skill.triggers)

    def test_scenario_selection_and_composition(self):
        cases = [
            ("web CTF challenge SQL injection", {"ctf-web"}),
            ("Linux ELF executable from pwn CTF", {"binary-analysis"}),
            ("Windows PE reverse engineer", {"binary-analysis"}),
            ("cryptography challenge with ciphertext", {"crypto-forensics"}),
            ("bug bounty web target", {"bug-bounty-web-api"}),
            ("API security assessment GraphQL", {"bug-bounty-web-api"}),
            ("network penetration test port scan", {"network-assessment"}),
            ("Active Directory domain assessment Kerberos", {"active-directory"}),
            ("Linux privilege escalation SUID", {"linux-assessment"}),
            ("Windows security assessment PowerShell", {"windows-assessment"}),
        ]
        for objective, expected in cases:
            with self.subTest(objective=objective):
                selected = {x["name"] for x in self.router.select(objective)}
                self.assertTrue(expected <= selected, (objective, selected))
        composed = {x["name"] for x in self.router.select("bug bounty API assessment, verify vulnerability")}
        self.assertIn("bug-bounty-web-api", composed)
        self.assertIn("finding-validation", composed)

    def test_exclusion_and_missing_skill_directory(self):
        self.assertNotIn("ctf-web", {x["name"] for x in self.router.select("live bug bounty web target")})
        self.assertEqual(SkillRouter(ROOT / "missing-skills").select("unknown task"), [])

    def test_malformed_and_duplicate_skills(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / "SKILL.md").write_text("not front matter")
            with self.assertRaises(SkillFormatError):
                SkillRouter(root)
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            metadata = {"name": "same-name", "description": "test skill", "domain": "test", "subdomains": [],
                        "triggers": ["test trigger"], "excludes": [], "prerequisites": [], "tools": [], "references": []}
            body = "\n".join(f"## {heading}\nTest." for heading in ("Methodology", "Decision", "Verification", "Safety", "Evidence"))
            source = f"---\n{json.dumps(metadata)}\n---\n{body}\n"
            (root / "a").mkdir(); (root / "b").mkdir()
            (root / "a/SKILL.md").write_text(source)
            (root / "b/SKILL.md").write_text(source)
            with self.assertRaises(SkillFormatError):
                SkillRouter(root)

    def test_refresh_picks_up_added_skill(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            router = SkillRouter(root)
            self.assertEqual(router.skills, {})
            (root / "new").mkdir()
            metadata = {"name": "new-domain", "description": "test skill", "domain": "test", "subdomains": [],
                        "triggers": ["new domain"], "excludes": [], "prerequisites": [], "tools": [], "references": []}
            body = "\n".join(f"## {heading}\nTest." for heading in ("Methodology", "Decision", "Verification", "Safety", "Evidence"))
            source = f"---\n{json.dumps(metadata)}\n---\n{body}\n"
            (root / "new/SKILL.md").write_text(source)
            router.refresh()
            self.assertIn("new-domain", router.skills)


class ToolAndPolicyTests(unittest.TestCase):
    def test_tool_registry_and_missing_status(self):
        registry = ToolRegistry(ROOT / "docs/security-work/tools.json")
        recommendations = registry.recommend(["network-assessment"], installed={"Nmap"})
        states = {x["name"]: x["status"] for x in recommendations}
        self.assertEqual(states["Nmap"], "installed")
        self.assertEqual(states["RustScan"], "missing")
        self.assertTrue(next(x for x in recommendations if x["name"] == "Nmap")["alternatives"])

    def test_scope_and_high_impact_gate(self):
        action = Action("scan", ("lab.local",))
        with self.assertRaises(AuthorizationError):
            authorize(action, None)
        scope = Scope("lab", frozenset({"lab.local"}), "written lab rules", frozenset({"scan"}), frozenset({"excluded.lab"}))
        authorize(action, scope)
        with self.assertRaises(AuthorizationError):
            authorize(Action("scan", ("other.local",)), scope)
        with self.assertRaises(AuthorizationError):
            authorize(Action("exploit", ("lab.local",), high_impact=True), scope)
        approved = Scope("lab", frozenset({"lab.local"}), "signed rules", frozenset({"exploit"}), explicit_high_impact=frozenset({"exploit"}))
        authorize(Action("exploit", ("lab.local",), high_impact=True), approved)
        authorize(Action("prepare", active=False), None)

    def test_tool_format_validation(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "tools.json"
            path.write_text(json.dumps([{"name": "incomplete"}]))
            with self.assertRaises(ValueError):
                ToolRegistry(path)


if __name__ == "__main__":
    unittest.main()
