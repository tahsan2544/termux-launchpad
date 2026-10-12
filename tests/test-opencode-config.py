#!/usr/bin/env python3
"""Offline smoke tests for the OpenCode/OmniRoute config helper."""
from __future__ import annotations

import json
import os
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HELPER = ROOT / "scripts" / "configure-opencode-omni.py"


def run_helper(home: Path, key: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(HELPER)],
        input=key + "\n",
        text=True,
        capture_output=True,
        env={**os.environ, "HOME": str(home)},
        check=False,
    )


def main() -> int:
    with tempfile.TemporaryDirectory() as tmp:
        home = Path(tmp)
        config = home / ".config" / "opencode" / "opencode.json"

        result = run_helper(home, "sk_test_dummy_not_real")
        assert result.returncode == 0, result.stderr
        data = json.loads(config.read_text(encoding="utf-8"))
        assert data["model"] == "omniroute/auto"
        assert data["provider"]["omniroute"]["options"]["apiKey"] == "sk_test_dummy_not_real"
        assert data["provider"]["omniroute"]["options"]["baseURL"] == "http://127.0.0.1:20128/v1"
        assert stat.S_IMODE(config.stat().st_mode) == 0o600

        # Ensure a second run preserves existing valid config fields and makes a backup.
        data["theme"] = "dark"
        config.write_text(json.dumps(data), encoding="utf-8")
        result = run_helper(home, "sk_test_second_dummy")
        assert result.returncode == 0, result.stderr
        updated = json.loads(config.read_text(encoding="utf-8"))
        assert updated["theme"] == "dark"
        assert updated["provider"]["omniroute"]["options"]["apiKey"] == "sk_test_second_dummy"
        assert list(config.parent.glob("opencode.json.backup-*")), "expected a config backup"

        # Invalid JSON must not be overwritten.
        config.write_text("{invalid json\n", encoding="utf-8")
        result = run_helper(home, "sk_test_will_not_be_saved")
        assert result.returncode != 0
        assert config.read_text(encoding="utf-8") == "{invalid json\n"

    print("OpenCode/OmniRoute config tests passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
