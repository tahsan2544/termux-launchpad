# Termux Launchpad library: common

say() { printf '%s\n' "$*"; }

ok() { printf '%s[OK]%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }

warn() { printf '%s[NOTE]%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }

err() { printf '%s[ERROR]%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }

has() { command -v "$1" >/dev/null 2>&1; }

ask_yes_no() {
  local question="$1" default="${2:-N}" reply
  if [ ! -t 0 ]; then [ "$default" = "Y" ]; return; fi
  if [ "$default" = "Y" ]; then
    read -r -p "$question [Y/n] " reply
    reply="${reply:-Y}"
  else
    read -r -p "$question [y/N] " reply
    reply="${reply:-N}"
  fi
  case "$reply" in Y|y|YES|yes|Yes) return 0;; *) return 1;; esac
}

require_termux() {
  case "${PREFIX:-}" in
    */com.termux/files/usr|*/com.termux.dev/files/usr|*/com.termux.api/files/usr) return 0 ;;
    *) err "Run this command inside Termux on Android."; return 1 ;;
  esac
}

project_name_from_args() {
  local name="$*"
  if [ -z "$name" ]; then err "Give a project name. Example: newproject UnitedCraft"; return 1; fi
  case "$name" in */*|*\\*|.*|*".."*) err "Use a simple project name without slashes or '..'."; return 1;; esac
  printf '%s' "$name"
}

is_debian_installed() {
  has proot-distro || return 1
  proot-distro login debian -- /bin/true >/dev/null 2>&1
}

ensure_projects() { mkdir -p "$PROJECTS_DIR" "$BACKUPS_DIR" "$LOG_DIR"; }

