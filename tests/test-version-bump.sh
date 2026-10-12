#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
printf '1.00\n' > "$tmp/VERSION"
result="$(bash "$ROOT/scripts/bump-version.sh" "$tmp/VERSION")"
[ "$result" = "1.01" ] || { echo "expected 1.01, got $result" >&2; exit 1; }
printf '1.99\n' > "$tmp/VERSION"
result="$(bash "$ROOT/scripts/bump-version.sh" "$tmp/VERSION")"
[ "$result" = "2.00" ] || { echo "expected 2.00, got $result" >&2; exit 1; }
printf 'bad-version\n' > "$tmp/VERSION"
if bash "$ROOT/scripts/bump-version.sh" "$tmp/VERSION" >/dev/null 2>&1; then
  echo "invalid version should have failed" >&2; exit 1
fi
echo "Version bump tests passed."
