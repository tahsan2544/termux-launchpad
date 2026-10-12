# Termux Launchpad library: ai-tools

cmd_debian() {
  require_termux || return 1
  if ! has proot-distro; then err "PRoot-Distro is missing. Run launchpad, then choose 'Install Termux base tools'."; return 1; fi
  if ! is_debian_installed; then err "Debian is not installed. Run: launchpad then choose 'Install Debian'."; return 1; fi
  exec proot-distro login debian
}

cmd_oc() {
  require_termux || return 1
  if ! has proot-distro; then err "PRoot-Distro is missing. Install Termux base tools first."; return 1; fi
  if ! is_debian_installed; then err "Debian is not installed. Run: launchpad then choose 'Install Debian'."; return 1; fi
  local host_dir="$PWD"
  case "$host_dir" in "$HOME"|"$HOME"/*) ;; *) host_dir="$PROJECTS_DIR";; esac
  [ -d "$host_dir" ] || host_dir="$HOME"
  exec proot-distro login debian -- bash -lc '
    target="$1"
    shift
    if [ -d "$target" ]; then cd "$target" || exit 1; fi
    export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"
    if command -v opencode >/dev/null 2>&1; then
      exec opencode "$@"
    fi
    echo "OpenCode is not installed in Debian. In Termux, run: ocinstall"
    echo "Opening a Debian shell instead."
    exec bash -l
  ' launchpad-oc "$host_dir" "$@"
}

cmd_linux() { cmd_oc "$@"; }

cmd_ocinstall() {
  require_termux || return 1
  has proot-distro || { err "Install Termux base tools first."; return 1; }
  is_debian_installed || { err "Install Debian first: launchpad -> Install Debian."; return 1; }
  if ! ask_yes_no "Install OpenCode using the official installer inside Debian?" N; then
    say "Cancelled. Read docs/OPENCODE_GUIDE.md first if you'd like."; return 0
  fi
  bash "$INSTALL_DIR/scripts/opencode-install.sh"
}

cmd_ocversion() {
  if ! is_debian_installed; then err "Debian is not installed."; return 1; fi
  proot-distro login debian -- bash -lc 'export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"; opencode --version'
}

cmd_install_debian() {
  require_termux || return 1
  if ! ask_yes_no "Download/install Debian or update its base packages? This can use substantial storage." N; then
    say "Cancelled."; return 0
  fi
  bash "$INSTALL_DIR/scripts/debian-install.sh"
}

cmd_install_termux() {
  require_termux || return 1
  bash "$INSTALL_DIR/scripts/termux-packages.sh"
  ensure_projects
  mkdir -p "$LOG_DIR"
  if [ ! -d "$HOME/storage/shared" ] && has termux-setup-storage; then
    if ask_yes_no "Connect Android shared storage for file-manager access?" Y; then termux-setup-storage || true; fi
  fi
  mkdir -p "$SHARED_PROJECTS_DIR" 2>/dev/null || true
  ok "Termux base tools installed. Debian, OpenCode and OmniRoute remain optional."
}

cmd_omniinstall() {
  require_termux || return 1
  bash "$INSTALL_DIR/scripts/omniroute-install.sh"
}

cmd_omni() {
  require_termux || return 1
  if ! has omniroute; then
    err "OmniRoute is not installed. Run: omniinstall"
    return 1
  fi
  exec omniroute "$@"
}

cmd_omnibg() {
  require_termux || return 1
  has omniroute || { err "Install OmniRoute first: omniinstall"; return 1; }
  mkdir -p "$LOG_DIR"
  if [ -f "$OMNI_PID_FILE" ]; then
    local oldpid
    oldpid="$(cat "$OMNI_PID_FILE" 2>/dev/null || true)"
    if [ -n "$oldpid" ] && kill -0 "$oldpid" 2>/dev/null; then
      warn "OmniRoute is already running (PID $oldpid). Dashboard: http://localhost:20128"; return 0
    fi
    rm -f "$OMNI_PID_FILE"
  fi
  nohup omniroute > "$LOG_DIR/omniroute.log" 2>&1 < /dev/null &
  echo "$!" > "$OMNI_PID_FILE"
  sleep 2
  cmd_omnistatus || { warn "It may still be starting. Check: $LOG_DIR/omniroute.log"; }
  say "Log file: $LOG_DIR/omniroute.log"
}

cmd_omnistop() {
  if [ ! -f "$OMNI_PID_FILE" ]; then say "No Launchpad-managed OmniRoute PID file found."; return 0; fi
  local pid
  pid="$(cat "$OMNI_PID_FILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" && ok "Stopped OmniRoute PID $pid."
  else
    say "The recorded OmniRoute process is not running."
  fi
  rm -f "$OMNI_PID_FILE"
}

omni_http_status() {
  has curl || return 1
  curl -sS --max-time 3 -o /dev/null -w '%{http_code}' http://127.0.0.1:20128/ 2>/dev/null
}

cmd_omnistatus() {
  local http_status
  http_status="$(omni_http_status 2>/dev/null || true)"
  if [[ "$http_status" =~ ^[1-5][0-9][0-9]$ ]]; then
    ok "OmniRoute responds at http://localhost:20128 (HTTP $http_status)"
  else
    warn "No response from OmniRoute at localhost:20128. Start it with: omni or omnibg"
    return 1
  fi
}

cmd_omniweb() {
  if has termux-open-url; then termux-open-url http://localhost:20128; else say "Open this address in your Android browser: http://localhost:20128"; fi
}

cmd_omniconnect() {
  require_termux || return 1
  has proot-distro || { err "Install Termux base tools first."; return 1; }
  is_debian_installed || { err "Install Debian first."; return 1; }
  if ! has omniroute; then err "Install OmniRoute first: omniinstall"; return 1; fi
  if ! ask_yes_no "Make OmniRoute the default provider in OpenCode's Debian config? Existing config will be backed up." N; then return 0; fi
  local key
  read -r -s -p "Paste the API key shown by the OmniRoute dashboard (input hidden): " key
  printf '\n'
  if [ -z "$key" ]; then err "No key entered."; return 1; fi
  if ! printf '%s\n' "$key" | proot-distro login debian -- python3 "$INSTALL_DIR/scripts/configure-opencode-omni.py"; then
    err "Could not update OpenCode config. Check Debian Python and docs/OMNIROUTE_GUIDE.md."; return 1
  fi
  unset key
  ok "Provider added. OpenCode default model is now omniroute/auto."
  say "Make sure OmniRoute is running and at least one provider is connected in its dashboard."
}

cmd_dupdate() { is_debian_installed || { err "Debian is not installed."; return 1; }; proot-distro login debian -- apt-get update; }

cmd_duupgrade() { is_debian_installed || { err "Debian is not installed."; return 1; }; proot-distro login debian -- bash -lc 'apt-get update && apt-get upgrade'; }

cmd_dstatus() {
  if ! has proot-distro; then warn "PRoot-Distro is not installed."; return 1; fi
  proot-distro list
  if is_debian_installed; then ok "Debian login works."; else warn "Debian is not installed or could not be started."; fi
  if is_debian_installed && proot-distro login debian -- bash -lc 'export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"; command -v opencode >/dev/null 2>&1'; then ok "OpenCode command exists inside Debian."; else warn "OpenCode is not installed inside Debian yet."; fi
}

