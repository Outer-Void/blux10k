"""`blux10k` command line (Stage 18).

    blux10k detect                 host facts (OS, arch, libc, Termux, PRoot, container)
    blux10k inventory              toolchain inventory with versions
    blux10k check GROUP...         python | node | jdk | gradle | android | termux | docker | git
    blux10k verify                 managed dotfiles + required tools, read-only
    blux10k report                 everything above as one diagnostic report
    blux10k doctor                 the report's verdict (exit 0 healthy, 1 problems)
    blux10k bootstrap [--apply]    show the bootstrap plan; run it only with --apply

Every command takes --json. Nothing changes the environment except `bootstrap --apply`.
Exit codes: 0 ok, 1 checks failed, 2 usage.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import Any

from blux10k_cli import __version__, probe

REPO = Path(__file__).resolve().parent.parent
GROUPS = ("python", "node", "jdk", "gradle", "android", "termux", "docker", "git")
MIN = {"python3": (3, 11), "node": (20, 0), "java": (17, 0)}


def _ver(v: str | None) -> tuple[int, ...]:
    if not v:
        return ()
    return tuple(int(x) for x in v.replace("_", ".").split(".")[:3] if x.isdigit())


def checks(groups: list[str], inv: dict[str, dict[str, Any]], host: probe.Host, sdk: dict[str, Any]) -> list[dict[str, str]]:
    out: list[dict[str, str]] = []

    def add(group: str, name: str, status: str, detail: str) -> None:
        out.append({"group": group, "check": name, "status": status, "detail": detail})

    def tool(group: str, name: str, required: bool = True) -> None:
        t = inv[name]
        if not t["present"]:
            add(group, name, "FAIL" if required else "WARN", "not found on PATH")
            return
        floor = MIN.get(name)
        if floor and _ver(t["version"])[: len(floor)] < floor:
            add(group, name, "FAIL", f"{t['version']} is older than {'.'.join(map(str, floor))}")
        else:
            add(group, name, "PASS", f"{t['version'] or 'unknown version'} at {t['path']}")

    for g in groups:
        if g == "python":
            tool(g, "python3")
            tool(g, "pip")
        elif g == "node":
            tool(g, "node")
            tool(g, "npm")
        elif g == "jdk":
            tool(g, "java")
            tool(g, "javac")
        elif g == "gradle":
            tool(g, "gradle", required=False)  # projects normally use ./gradlew
        elif g == "android":
            if not sdk["present"]:
                add(g, "sdk", "FAIL", "ANDROID_HOME / ANDROID_SDK_ROOT not set to an SDK directory")
            else:
                add(g, "sdk", "PASS", sdk["root"])
                add(g, "platform-tools", "PASS" if sdk["platform_tools"] else "FAIL", "adb in platform-tools")
                add(g, "build-tools", "PASS" if sdk["build_tools"] else "FAIL", ", ".join(sdk["build_tools"]) or "none installed")
            tool(g, "adb", required=False)
        elif g == "termux":
            if host.termux:
                add(g, "termux", "PASS", f"Termux environment; interpreter platform {host.os}")
            elif host.proot:
                add(g, "termux", "WARN", "PRoot guest: Termux packages belong to the host prefix, not this userland")
            else:
                add(g, "termux", "SKIP", "not an Android/Termux host")
        elif g == "docker":
            tool(g, "docker", required=False)
            if host.container:
                add(g, "inside-container", "WARN", f"running inside {host.container}")
        elif g == "git":
            tool(g, "git")
    return out


def dotfiles_status(home: Path) -> list[dict[str, str]]:
    """Read-only view of the managed dotfiles (the same entries scripts/link.sh manages)."""
    out = []
    for src in sorted((REPO / "dotfiles").iterdir()):
        dest = home / src.name
        if dest.is_symlink() and dest.resolve() == src.resolve():
            state = "linked"
        elif dest.exists():
            state = "present (not linked to blux10k)"
        else:
            state = "missing"
        out.append({"entry": src.name, "state": state})
    return out


BOOTSTRAP_PLAN = [
    ("ensure_dirs", ["bash", "scripts/ensure_dirs.sh"], "create ~/.config, ~/.local/bin and the blux10k state directory if missing"),
    ("backup", ["bash", "scripts/backup_dotfiles.sh"], "back up existing dotfiles before linking"),
    ("link", ["bash", "scripts/link.sh"], "symlink the managed dotfiles into $HOME"),
]


def report(groups: list[str] | None = None) -> dict[str, Any]:
    host = probe.detect()
    inv = probe.inventory()
    sdk = probe.android_sdk()
    results = checks(list(groups or GROUPS), inv, host, sdk)
    return {
        "contract": "blux10k.report", "blux10k_version": __version__, "host": host.to_dict(), "inventory": inv,
        "android_sdk": sdk, "checks": results, "dotfiles": dotfiles_status(Path.home()),
        "healthy": not any(c["status"] == "FAIL" for c in results),
    }


def _emit(doc: Any, as_json: bool, human: str) -> None:
    sys.stdout.write(json.dumps(doc, indent=1, sort_keys=True) + "\n" if as_json else human)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(prog="blux10k", description=__doc__.split("\n\n")[0])
    ap.add_argument("--version", action="version", version=f"blux10k {__version__}")
    sub = ap.add_subparsers(dest="cmd")
    for name in ("detect", "inventory", "verify", "report", "doctor"):
        sub.add_parser(name).add_argument("--json", action="store_true")
    c = sub.add_parser("check")
    c.add_argument("groups", nargs="+", choices=GROUPS)
    c.add_argument("--json", action="store_true")
    b = sub.add_parser("bootstrap")
    b.add_argument("--apply", action="store_true", help="run the plan (default: show it only)")
    b.add_argument("--json", action="store_true")
    args = ap.parse_args(argv)
    if args.cmd is None:
        ap.print_help(sys.stderr)
        return 2
    if args.cmd == "detect":
        h = probe.detect()
        _emit(h.to_dict(), args.json, "".join(f"{k:10} {v}\n" for k, v in h.to_dict().items()))
        return 0
    if args.cmd == "inventory":
        inv = probe.inventory()
        _emit(inv, args.json, "".join(f"{k:8} {'-' if not v['present'] else v['version'] or '?'}\n" for k, v in inv.items()))
        return 0
    if args.cmd == "check":
        res = checks(args.groups, probe.inventory(), probe.detect(), probe.android_sdk())
        _emit(res, args.json, "".join(f"[{r['status']:4}] {r['group']}/{r['check']}: {r['detail']}\n" for r in res))
        return 1 if any(r["status"] == "FAIL" for r in res) else 0
    if args.cmd == "verify":
        dots = dotfiles_status(Path.home())
        res = checks(["git", "python"], probe.inventory(), probe.detect(), probe.android_sdk())
        doc = {"dotfiles": dots, "checks": res}
        _emit(doc, args.json, "".join(f"{d['entry']:12} {d['state']}\n" for d in dots)
              + "".join(f"[{r['status']:4}] {r['check']}: {r['detail']}\n" for r in res))
        return 1 if any(r["status"] == "FAIL" for r in res) else 0
    if args.cmd in ("report", "doctor"):
        doc = report()
        if args.cmd == "doctor" and not args.json:
            bad = [c for c in doc["checks"] if c["status"] in ("FAIL", "WARN")]
            human = f"blux10k {__version__}: {'healthy' if doc['healthy'] else 'problems found'}\n" + "".join(
                f"[{c['status']:4}] {c['group']}/{c['check']}: {c['detail']}\n" for c in bad
            )
        else:
            h = doc["host"]
            human = (f"host     {h['os']} {h['machine']} libc={h['libc']} termux={h['termux']} proot={h['proot']} "
                     f"container={h['container']}\n" + "".join(f"[{c['status']:4}] {c['group']}/{c['check']}: {c['detail']}\n"
                                                              for c in doc["checks"]))
        _emit(doc, args.json, human)
        return 0 if doc["healthy"] else 1
    # bootstrap
    plan = [{"step": s, "command": " ".join(cmd), "effect": why} for s, cmd, why in BOOTSTRAP_PLAN]
    if not args.apply:
        _emit({"applied": False, "plan": plan}, args.json,
              "bootstrap plan (nothing changed; rerun with --apply):\n" + "".join(f"  {p['step']:12} {p['effect']}\n" for p in plan))
        return 0
    for step, cmd, _why in BOOTSTRAP_PLAN:
        code = subprocess.run(cmd, cwd=REPO, check=False, env=os.environ.copy()).returncode  # noqa: S603
        if code != 0:
            print(f"blux10k: bootstrap step {step} failed with exit {code}", file=sys.stderr)
            return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
