#!/usr/bin/env python3
"""Add a basic OmniRoute OpenAI-compatible provider to OpenCode's Debian config."""
from __future__ import annotations

import json
import os
import shutil
import sys
from datetime import datetime
from pathlib import Path

api_key = sys.stdin.readline().rstrip("\r\n")
if not api_key:
    print("No API key received; config was not changed.", file=sys.stderr)
    raise SystemExit(2)

config_dir = Path.home() / ".config" / "opencode"
config_file = config_dir / "opencode.json"
config_dir.mkdir(parents=True, exist_ok=True)

if config_file.exists():
    try:
        existing = json.loads(config_file.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError) as exc:
        print(
            f"Existing config is not valid plain JSON ({exc}). It was left untouched. "
            "Back up/fix JSONC comments manually, then retry.",
            file=sys.stderr,
        )
        raise SystemExit(3)
    if not isinstance(existing, dict):
        print("Existing config root must be a JSON object; left untouched.", file=sys.stderr)
        raise SystemExit(3)
    backup = config_file.with_name(
        f"opencode.json.backup-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
    )
    shutil.copy2(config_file, backup)
else:
    existing = {}
    backup = None

existing["$schema"] = "https://opencode.ai/config.json"
providers = existing.setdefault("provider", {})
if not isinstance(providers, dict):
    print("Existing 'provider' value is not an object; left untouched.", file=sys.stderr)
    raise SystemExit(3)
providers["omniroute"] = {
    "npm": "@ai-sdk/openai-compatible",
    "name": "OmniRoute (local)",
    "options": {
        "baseURL": "http://127.0.0.1:20128/v1",
        "apiKey": api_key,
    },
    "models": {
        "auto": {
            "name": "OmniRoute Auto Router",
            "limit": {"context": 128000, "output": 8192},
        }
    },
}
existing["model"] = "omniroute/auto"

tmp = config_file.with_suffix(".json.tmp")
tmp.write_text(json.dumps(existing, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
os.chmod(tmp, 0o600)
tmp.replace(config_file)
os.chmod(config_file, 0o600)
if backup:
    print(f"Previous OpenCode config backed up to: {backup}")
print(f"Configured OmniRoute in: {config_file}")
print("API key is stored in this local config file. Do not commit or share it.")
