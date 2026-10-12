#!/usr/bin/env bash
set -euo pipefail
case "${PREFIX:-}" in */com.termux/files/usr|*/com.termux.dev/files/usr|*/com.termux.api/files/usr) ;; *) echo "Run this from Termux, not inside Debian." >&2; exit 1;; esac
command -v proot-distro >/dev/null 2>&1 || { echo "PRoot-Distro is missing. Run the Launchpad base setup first." >&2; exit 1; }
proot-distro login debian -- /bin/true >/dev/null 2>&1 || { echo "Debian is not installed. Run the Debian setup first." >&2; exit 1; }
proot-distro login debian -- bash -lc '
  set -e
  apt-get update
  apt-get install -y ca-certificates curl
  # Official OpenCode install instructions: https://docs.opencode.ai/docs/
  curl -fsSL https://opencode.ai/install | bash
  export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"
  opencode --version
'
echo "OpenCode installation finished. Launch with: linux"
