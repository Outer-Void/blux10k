"""blux10k CLI tests (stdlib unittest): detection, inventory, checks, read-only guarantees."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO))

from blux10k_cli import cli, probe  # noqa: E402

BIN = REPO / "bin" / "blux10k"


def snapshot(root: Path) -> dict[str, float]:
    return {str(p.relative_to(root)): p.stat().st_mtime for p in root.rglob("*")}


class Detection(unittest.TestCase):
    def test_termux_bionic(self) -> None:
        h = probe.detect({"PREFIX": "/data/data/com.termux/files/usr", "TERMUX_VERSION": "0.118"}, Path("/nonexistent"),
                         kernel="6.1.0-android14", sysplatform="android")
        self.assertTrue(h.termux)
        self.assertEqual(h.libc, "bionic")
        self.assertFalse(h.proot)

    def test_proot_guest_is_not_termux(self) -> None:
        h = probe.detect({}, Path("/nonexistent"), kernel="6.17.0-PRoot-Distro", sysplatform="linux")
        self.assertTrue(h.proot)
        self.assertFalse(h.termux)
        self.assertTrue(any("PRoot" in n for n in h.notes))

    def test_termux_variables_under_a_glibc_interpreter_are_flagged(self) -> None:
        h = probe.detect({"TERMUX_VERSION": "0.118"}, Path("/nonexistent"), kernel="6.1", sysplatform="linux")
        self.assertTrue(any("not Bionic" in n for n in h.notes))

    def test_container_markers(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            Path(tmp, ".dockerenv").touch()
            self.assertEqual(probe.detect({}, Path(tmp), kernel="6", sysplatform="linux").container, "docker")


class Inventory(unittest.TestCase):
    def test_versions_and_missing_tools(self) -> None:
        present = {"python3": "Python 3.12.4", "java": 'openjdk version "17.0.11" 2024-04-16', "node": "v18.19.0"}

        def which(name: str) -> str | None:
            return f"/usr/bin/{name}" if name in present or name == "python3" else None

        def runner(argv: list[str]) -> tuple[int, str]:
            if argv[:3] == ["python3", "-m", "pip"]:
                return 0, "pip 24.0 from /x"
            return 0, present.get(argv[0], "")

        inv = probe.inventory(which, runner)
        self.assertEqual(inv["python3"]["version"], "3.12.4")
        self.assertEqual(inv["java"]["version"], "17.0.11")
        self.assertFalse(inv["gradle"]["present"])
        host = probe.Host("linux", "aarch64", "glibc", "6", False, False, None, False, "3.12")
        sdk = {"present": False, "root": None, "platform_tools": False, "build_tools": [], "platforms": []}
        res = {r["check"]: r["status"] for r in cli.checks(["python", "node", "jdk", "gradle", "android"], inv, host, sdk)}
        self.assertEqual(res["python3"], "PASS")
        self.assertEqual(res["node"], "FAIL")  # 18 is older than the Node 20 floor
        self.assertEqual(res["gradle"], "WARN")  # optional: projects use ./gradlew
        self.assertEqual(res["sdk"], "FAIL")

    def test_android_sdk_layout(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "platform-tools").mkdir()
            (root / "platform-tools" / "adb").touch()
            (root / "build-tools" / "35.0.0").mkdir(parents=True)
            sdk = probe.android_sdk({"ANDROID_HOME": tmp})
            self.assertTrue(sdk["present"] and sdk["platform_tools"])
            self.assertEqual(sdk["build_tools"], ["35.0.0"])


class ReadOnly(unittest.TestCase):
    def run_cli(self, *args: str, home: Path) -> subprocess.CompletedProcess[str]:
        env = {**os.environ, "HOME": str(home)}
        return subprocess.run([sys.executable, str(BIN), *args], capture_output=True, text=True, env=env, timeout=300, check=False)

    def test_no_command_changes_the_environment(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            home = Path(tmp)
            (home / ".zshrc").write_text("# mine\n")
            before = snapshot(home)
            for args in (["detect"], ["inventory", "--json"], ["check", "python"], ["verify"], ["report", "--json"],
                         ["doctor"], ["bootstrap"], ["bootstrap", "--json"]):
                proc = self.run_cli(*args, home=home)
                self.assertIn(proc.returncode, (0, 1), (args, proc.stderr))
            self.assertEqual(snapshot(home), before)
            self.assertEqual((home / ".zshrc").read_text(), "# mine\n")

    def test_bootstrap_shows_a_plan_without_apply(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            proc = self.run_cli("bootstrap", "--json", home=Path(tmp))
            doc = json.loads(proc.stdout)
            self.assertFalse(doc["applied"])
            self.assertEqual([p["step"] for p in doc["plan"]], ["ensure_dirs", "backup", "link"])

    def test_report_contract(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            doc = json.loads(self.run_cli("report", "--json", home=Path(tmp)).stdout)
            self.assertEqual(doc["contract"], "blux10k.report")
            self.assertEqual({e["entry"] for e in doc["dotfiles"]}, {".bashrc", ".gitconfig", ".p10k.zsh", ".profile", ".zshrc"})
            self.assertTrue(all(e["state"] == "missing" for e in doc["dotfiles"]))

    def test_usage_error(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            self.assertEqual(self.run_cli(home=Path(tmp)).returncode, 2)
            self.assertEqual(self.run_cli("check", "fortran", home=Path(tmp)).returncode, 2)


if __name__ == "__main__":
    unittest.main()
