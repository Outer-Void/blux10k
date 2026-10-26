"""Host detection and toolchain inventory. Every function is read-only and takes injectable inputs for tests."""

from __future__ import annotations

import os
import platform
import re
import shutil
import subprocess
import sys
import tempfile
from collections.abc import Callable, Mapping
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

Runner = Callable[[list[str]], tuple[int, str]]


def run(argv: list[str], timeout: float = 15) -> tuple[int, str]:
    """Run a version probe. Never raises; a missing or hanging tool is just a failed probe.

    Probes run with HOME and tool homes pointed at a throwaway directory: `adb version` would otherwise create
    ~/.android and `gradle --version` ~/.gradle, and blux10k never changes the environment it inspects.
    """
    with tempfile.TemporaryDirectory(prefix="blux10k-probe-") as scratch:
        env = {**os.environ, "HOME": scratch, "GRADLE_USER_HOME": f"{scratch}/gradle", "ANDROID_USER_HOME": f"{scratch}/android",
               "XDG_CONFIG_HOME": f"{scratch}/config", "XDG_CACHE_HOME": f"{scratch}/cache", "XDG_DATA_HOME": f"{scratch}/data"}
        try:
            proc = subprocess.run(argv, capture_output=True, text=True, timeout=timeout, check=False, env=env, cwd=scratch)  # noqa: S603
        except (OSError, subprocess.TimeoutExpired) as exc:
            return 127, type(exc).__name__
    return proc.returncode, (proc.stdout + proc.stderr).strip()


@dataclass
class Host:
    os: str
    machine: str
    libc: str
    kernel: str
    termux: bool
    proot: bool
    container: str | None
    wsl: bool
    python: str
    notes: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return dict(self.__dict__)


def _read(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


def detect(env: Mapping[str, str] | None = None, root: Path = Path("/"), *, kernel: str | None = None,
           sysplatform: str = sys.platform) -> Host:
    env = os.environ if env is None else env
    kernel = kernel if kernel is not None else platform.release()
    prefix = env.get("PREFIX", "")
    termux_prefix = Path("/data/data/com.termux/files/usr")
    termux = bool(env.get("TERMUX_VERSION")) or prefix.startswith(str(termux_prefix)) or sysplatform == "android"
    status = _read(root / "proc" / "self" / "status")
    tracer = re.search(r"^TracerPid:\s+(\d+)", status, re.M)
    proot = "proot" in kernel.lower() or bool(env.get("PROOT_TMP_DIR")) or (
        bool(tracer and tracer.group(1) != "0") and (root / termux_prefix.relative_to("/")).exists()
    )
    container = None
    if (root / ".dockerenv").exists() or "docker" in _read(root / "proc" / "1" / "cgroup"):
        container = "docker"
    elif (root / "run" / ".containerenv").exists():
        container = "podman"
    libc = "bionic" if sysplatform == "android" else (platform.libc_ver()[0] or ("musl" if (root / "lib" / "ld-musl-aarch64.so.1").exists() else "unknown"))
    notes = []
    if proot and not termux:
        notes.append("PRoot guest on Android: glibc userland over an Android kernel; Bionic binaries live in the Termux prefix")
    if termux and sysplatform != "android":
        notes.append("Termux environment variables present but this interpreter is not Bionic (inspect sys.platform, not uname)")
    return Host(
        os=sysplatform, machine=platform.machine(), libc=libc, kernel=kernel, termux=termux, proot=proot,
        container=container, wsl="microsoft" in kernel.lower(), python=platform.python_version(), notes=notes,
    )


# tool -> (version argv, regex for the version number)
TOOLS: dict[str, tuple[list[str], str]] = {
    "python3": (["python3", "--version"], r"(\d+\.\d+(?:\.\d+)?)"),
    "pip": (["python3", "-m", "pip", "--version"], r"pip (\d+\.\d+(?:\.\d+)?)"),
    "node": (["node", "--version"], r"v?(\d+\.\d+\.\d+)"),
    "npm": (["npm", "--version"], r"(\d+\.\d+\.\d+)"),
    "java": (["java", "-version"], r"version \"?(\d+[\d._]*)"),
    "javac": (["javac", "-version"], r"javac (\d+[\d._]*)"),
    "gradle": (["gradle", "--version"], r"Gradle (\d+\.\d+(?:\.\d+)?)"),
    "adb": (["adb", "version"], r"version (\d+\.\d+\.\d+)"),
    "git": (["git", "--version"], r"(\d+\.\d+\.\d+)"),
    "zsh": (["zsh", "--version"], r"(\d+\.\d+(?:\.\d+)?)"),
    "docker": (["docker", "--version"], r"(\d+\.\d+\.\d+)"),
    "uv": (["uv", "--version"], r"(\d+\.\d+\.\d+)"),
    "gh": (["gh", "--version"], r"(\d+\.\d+\.\d+)"),
    "rustc": (["rustc", "--version"], r"(\d+\.\d+\.\d+)"),
}


def inventory(which: Callable[[str], str | None] = shutil.which, runner: Runner = run) -> dict[str, dict[str, Any]]:
    out: dict[str, dict[str, Any]] = {}
    for tool, (argv, rx) in TOOLS.items():
        path = which(argv[0])
        if path is None:
            out[tool] = {"present": False, "path": None, "version": None}
            continue
        code, text = runner(argv)
        m = re.search(rx, text)
        out[tool] = {"present": code == 0 or m is not None, "path": path, "version": m.group(1) if m else None}
    return out


def android_sdk(env: Mapping[str, str] | None = None) -> dict[str, Any]:
    env = os.environ if env is None else env
    root = next((Path(env[k]) for k in ("ANDROID_HOME", "ANDROID_SDK_ROOT") if env.get(k)), None)
    if root is None or not root.is_dir():
        return {"present": False, "root": str(root) if root else None, "platform_tools": False, "build_tools": [], "platforms": []}
    def versions(sub: str) -> list[str]:
        d = root / sub
        return sorted(p.name for p in d.iterdir() if p.is_dir()) if d.is_dir() else []

    return {
        "present": True, "root": str(root), "platform_tools": (root / "platform-tools" / "adb").exists(),
        "build_tools": versions("build-tools"), "platforms": versions("platforms"),
        "cmdline_tools": (root / "cmdline-tools").is_dir(),
    }
