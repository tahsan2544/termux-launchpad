#!/usr/bin/env bash
set -euo pipefail
VERSION_FILE="${1:-VERSION}"
[ -f "$VERSION_FILE" ] || { echo "Version file not found: $VERSION_FILE" >&2; exit 1; }
current="$(tr -d '[:space:]' < "$VERSION_FILE")"
if [[ ! "$current" =~ ^([0-9]+)\.([0-9]{2})$ ]]; then
  echo "Unsupported version '$current'. Expected MAJOR.MINOR, e.g. 1.00." >&2
  exit 1
fi
major=$((10#${BASH_REMATCH[1]}))
minor=$((10#${BASH_REMATCH[2]} + 1))
if (( minor > 99 )); then major=$((major + 1)); minor=0; fi
tmp="${VERSION_FILE}.tmp.$$"
printf '%d.%02d\n' "$major" "$minor" > "$tmp"
mv "$tmp" "$VERSION_FILE"
printf '%s\n' "$(cat "$VERSION_FILE")"
