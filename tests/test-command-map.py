#!/usr/bin/env python3
"""Ensure every documented shortcut has a dispatcher case."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
commands = {
    line.strip()
    for line in (ROOT / "config" / "commands.txt").read_text(encoding="utf-8").splitlines()
    if line.strip()
}
main = (ROOT / "bin" / "launchpad").read_text(encoding="utf-8")
case = main.split('case "$COMMAND" in', 1)[1]
labels: set[str] = set()
for line in case.splitlines():
    match = re.match(r"\s*([a-zA-Z0-9_-]+(?:\|[a-zA-Z0-9_-]+)*)\)\s*", line)
    if match:
        labels.update(match.group(1).split("|"))
missing = sorted(commands - labels)
extra = sorted(labels - commands)
if missing or extra:
    raise SystemExit(f"Command map mismatch. Missing cases: {missing}; undocumented cases: {extra}")
print(f"Command map test passed ({len(commands)} shortcuts).")
