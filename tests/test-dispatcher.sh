#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home"' EXIT
output="$(HOME="$tmp_home" bash "$ROOT/bin/launchpad" helpme)"
case "$output" in *"TERMUX LAUNCHPAD — COMMAND GUIDE"*"omniconnect"*) ;; *) echo "help command output missing expected shortcuts" >&2; exit 1;; esac
HOME="$tmp_home" bash "$ROOT/bin/launchpad" newproject "Smoke Test" >/dev/null
[ -f "$tmp_home/Projects/Smoke Test/README.md" ] || { echo "newproject did not create README" >&2; exit 1; }
list="$(HOME="$tmp_home" bash "$ROOT/bin/launchpad" projectlist)"
case "$list" in *"Smoke Test"*) ;; *) echo "projectlist did not show created project" >&2; exit 1;; esac
HOME="$tmp_home" bash "$ROOT/bin/launchpad" backup "Smoke Test" >/dev/null
find "$tmp_home/ProjectBackups" -type f -name '*.tar.gz' | grep -q . || { echo "backup archive missing" >&2; exit 1; }
echo "Dispatcher smoke tests passed."
