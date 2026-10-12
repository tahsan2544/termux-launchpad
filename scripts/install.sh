#!/usr/bin/env bash
set -euo pipefail
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
INSTALL_DIR="$HOME/.termux-launchpad"

case "${PREFIX:-}" in
  */com.termux/files/usr|*/com.termux.dev/files/usr|*/com.termux.api/files/usr) ;;
  *) echo "ERROR: Run this installer inside Termux on Android." >&2; exit 1 ;;
esac

ask() {
  local prompt="$1" default="${2:-Y}" answer
  if [ ! -t 0 ]; then [ "$default" = "Y" ]; return; fi
  if [ "$default" = "Y" ]; then read -r -p "$prompt [Y/n] " answer; answer="${answer:-Y}"; else read -r -p "$prompt [y/N] " answer; answer="${answer:-N}"; fi
  case "$answer" in y|Y|yes|YES|Yes) return 0;; *) return 1;; esac
}

if [ "$SOURCE_DIR" != "$INSTALL_DIR" ] && [ "${1:-}" != "--installed" ]; then
  if [ -e "$INSTALL_DIR" ] && [ "$(find "$INSTALL_DIR" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l | tr -d ' ')" != "0" ]; then
    if ! ask "Install/update files in $INSTALL_DIR? Existing files may be replaced." N; then
      echo "Cancelled. For a Git checkout, clone directly into $INSTALL_DIR and run install.sh there."
      exit 1
    fi
    backup="$HOME/.termux-launchpad.backup-$(date +%Y%m%d-%H%M%S)"
    cp -R "$INSTALL_DIR" "$backup"
    echo "Previous installation backed up to: $backup"
  fi
  mkdir -p "$INSTALL_DIR"
  tar --exclude='./.git' --exclude='./.git/*' -C "$SOURCE_DIR" -cf - . | tar -C "$INSTALL_DIR" -xf -
  exec bash "$INSTALL_DIR/scripts/install.sh" --installed
fi

mkdir -p "$HOME/Projects" "$HOME/ProjectBackups" "$HOME/.termux-launchpad/logs" "$HOME/bin"

if ! command -v pkg >/dev/null 2>&1; then
  echo "ERROR: Termux pkg manager was not found." >&2
  exit 1
fi

if ask "Install recommended Termux tools (Git, Node.js, Python, Debian tools)?" Y; then
  bash "$INSTALL_DIR/scripts/termux-packages.sh"
fi

if [ ! -d "$HOME/storage/shared" ] && command -v termux-setup-storage >/dev/null 2>&1; then
  if ask "Request Android shared-storage permission now?" Y; then
    termux-setup-storage || true
  fi
fi
if [ -d "$HOME/storage/shared" ]; then mkdir -p "$HOME/storage/shared/Projects"; fi

bash "$INSTALL_DIR/scripts/install-shortcuts.sh"

cat <<'BANNER'

Termux Launchpad is installed.

Start here:
  launchpad     Beginner-friendly interactive menu
  helpme        All shortcuts
  dashboard     System status
  lpdoctor      Diagnose common setup issues

Next: launchpad -> Install Debian -> Install OpenCode / OmniRoute as needed.
BANNER

if [ -t 0 ] && ask "Open the Launchpad menu now?" Y; then
  "$HOME/bin/launchpad"
fi
