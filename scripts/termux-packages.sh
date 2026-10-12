#!/usr/bin/env bash
set -euo pipefail
case "${PREFIX:-}" in */com.termux/files/usr|*/com.termux.dev/files/usr|*/com.termux.api/files/usr) ;; *) echo "Run inside Termux." >&2; exit 1;; esac
pkg update
pkg install -y git curl wget nano jq nodejs-lts python build-essential proot-distro openssh tree zip unzip coreutils findutils grep sed tar
mkdir -p "$HOME/Projects" "$HOME/ProjectBackups" "$HOME/.termux-launchpad/logs" "$HOME/bin"
echo "Base packages installed. Optional: install Debian, OpenCode, and OmniRoute from the Launchpad menu."
