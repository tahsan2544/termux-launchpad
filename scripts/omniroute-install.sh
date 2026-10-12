#!/usr/bin/env bash
set -euo pipefail
case "${PREFIX:-}" in */com.termux/files/usr|*/com.termux.dev/files/usr|*/com.termux.api/files/usr) ;; *) echo "Run OmniRoute installation from Termux." >&2; exit 1;; esac
pkg install -y nodejs-lts python build-essential git
node --version
npm --version
npm install -g omniroute
omniroute --version 2>/dev/null || true
echo "OmniRoute installed. Run 'omni' to start it or 'omnibg' for background mode."
echo "If native dependencies fail, check the current upstream Termux guide: https://github.com/diegosouzapw/OmniRoute"
