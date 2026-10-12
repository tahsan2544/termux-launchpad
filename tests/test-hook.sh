#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp -R "$ROOT/.githooks" "$ROOT/scripts" "$tmp/"
cp "$ROOT/VERSION" "$tmp/VERSION"
printf '# test\n' > "$tmp/README.md"
git -C "$tmp" init -q
git -C "$tmp" config user.name "Launchpad Test"
git -C "$tmp" config user.email "launchpad-test@example.invalid"
git -C "$tmp" add VERSION README.md
TERMUX_LAUNCHPAD_SKIP_VERSION_BUMP=1 git -C "$tmp" commit -qm "initial test commit"
git -C "$tmp" config core.hooksPath .githooks
printf '\nTest edit\n' >> "$tmp/README.md"
git -C "$tmp" add README.md
git -C "$tmp" -c core.hooksPath=.githooks commit -m "test auto version hook" >/dev/null
version="$(tr -d '[:space:]' < "$tmp/VERSION")"
[ "$version" = "1.01" ] || { echo "hook expected 1.01, got $version" >&2; exit 1; }
git -C "$tmp" show HEAD:VERSION | grep -qx '1.01' || { echo "VERSION not included in commit" >&2; exit 1; }
echo "Git hook test passed: commit contains VERSION 1.01."
