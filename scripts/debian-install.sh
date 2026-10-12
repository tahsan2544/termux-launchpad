#!/usr/bin/env bash
set -euo pipefail
case "${PREFIX:-}" in */com.termux/files/usr|*/com.termux.dev/files/usr|*/com.termux.api/files/usr) ;; *) echo "Run this from Termux, not inside Debian." >&2; exit 1;; esac
if ! command -v proot-distro >/dev/null 2>&1; then
  pkg install -y proot-distro
fi
if ! proot-distro login debian -- /bin/true >/dev/null 2>&1; then
  proot-distro install debian
fi
proot-distro login debian -- bash -lc 'apt-get update && apt-get upgrade -y && apt-get install -y ca-certificates curl git nano python3 python3-venv unzip zip jq'
echo "Debian setup is complete. Start it with: debian"
