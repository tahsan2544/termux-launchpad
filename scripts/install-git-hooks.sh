#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Run this inside the repository root or one of its subfolders." >&2; exit 1; }
[ -f "$ROOT/.githooks/pre-commit" ] || { echo "Missing .githooks/pre-commit" >&2; exit 1; }
chmod +x "$ROOT/.githooks/pre-commit" "$ROOT/scripts/bump-version.sh"
git -C "$ROOT" config core.hooksPath .githooks
echo "Installed local Git hooks for $ROOT"
echo "Each normal commit will bump VERSION as part of that commit."
