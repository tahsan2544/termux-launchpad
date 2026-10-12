# Termux Launchpad library: system

cmd_update() { require_termux || return 1; pkg update && pkg upgrade; }

cmd_dashboard() {
  ensure_projects
  local version='unknown' count storage_avail node_label='not installed' omni_label='stopped' opencode_label='not installed'
  [ -f "$INSTALL_DIR/VERSION" ] && version="$(cat "$INSTALL_DIR/VERSION")"
  count="$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  storage_avail="$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $4 " free of " $2}')"
  has node && node_label="$(node --version 2>/dev/null || echo installed)"
  local debian_label='not-installed'
  local omni_code
  omni_code="$(omni_http_status 2>/dev/null || true)"
  if [[ "$omni_code" =~ ^[1-5][0-9][0-9]$ ]]; then omni_label="online at localhost:20128 (HTTP $omni_code)"; fi
  if is_debian_installed; then
    debian_label='installed'
    if proot-distro login debian -- bash -lc 'export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"; command -v opencode >/dev/null 2>&1'; then opencode_label='installed in Debian'; fi
  fi
  printf '\n%s\n' "${C_BLUE}╔══════════════════════════════════════════╗${C_RESET}"
  printf '%s\n' "${C_BLUE}║          TERMUX LAUNCHPAD                 ║${C_RESET}"
  printf '%s\n' "${C_BLUE}╚══════════════════════════════════════════╝${C_RESET}"
  printf 'Version:       %s\n' "$version"
  printf 'Projects:      %s (%s)\n' "$count" "$PROJECTS_DIR"
  printf 'Storage:       %s\n' "${storage_avail:-unknown}"
  printf 'Node.js:       %s\n' "$node_label"
  printf 'Debian:        %s\n' "$debian_label"
  printf 'OpenCode:      %s\n' "$opencode_label"
  printf 'OmniRoute:     %s\n' "$omni_label"
  printf 'Git:           %s\n' "$(git --version 2>/dev/null || echo not-installed)"
  say "Quick commands: helpme | newproject NAME | projectlist | dashboard | lpdoctor"
  say ""
}

cmd_lpdoctor() {
  say "Termux Launchpad diagnostics"
  printf 'Platform:       '; if require_termux >/dev/null 2>&1; then say "Termux detected"; else say "not Termux"; fi
  printf 'Install folder: %s\n' "$INSTALL_DIR"
  printf 'Commands path:  '; case ":$PATH:" in *":$HOME/bin:"*) say "~/bin is in PATH";; *) warn "~/bin is not in PATH; reopen Termux or add it to shell startup.";; esac
  printf 'Projects:       '; if [ -d "$PROJECTS_DIR" ]; then say "present"; else warn "missing (will be created)"; fi
  printf 'Git:            '; git --version 2>/dev/null || warn "not installed"
  printf 'Node.js:        '; node --version 2>/dev/null || warn "not installed"
  printf 'npm:            '; npm --version 2>/dev/null || warn "not installed"
  printf 'PRoot-Distro:   '; if has proot-distro; then proot-distro --version 2>/dev/null || say "installed"; else warn "not installed"; fi
  printf 'Debian:         '; if is_debian_installed; then say "login works"; else warn "not installed or login fails"; fi
  printf 'OpenCode:       '; if is_debian_installed && proot-distro login debian -- bash -lc 'export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"; command -v opencode >/dev/null 2>&1'; then say "installed in Debian"; else warn "not installed in Debian"; fi
  printf 'OmniRoute:      '; if has omniroute; then omniroute --version 2>/dev/null || say "installed"; else warn "not installed"; fi
  printf 'Disk:           '; df -h "$HOME" | awk 'NR==2 {print $4 " free"}'
  say "For fixes, read docs/TROUBLESHOOTING.md"
}

cmd_lpupdate() {
  if [ ! -d "$INSTALL_DIR/.git" ]; then
    err "This is a runtime copy, not a Git checkout. To update, clone the repository into ~/.termux-launchpad or reinstall from the latest release."
    return 1
  fi
  git -C "$INSTALL_DIR" pull --ff-only
}

cmd_lpversion() { cat "$INSTALL_DIR/VERSION" 2>/dev/null || say "version unknown"; }

cmd_uninstall_launchpad() {
  warn "This removes Launchpad's installed shortcut links and PATH block. It does not remove Debian, projects, backups, OpenCode, or OmniRoute."
  if ! ask_yes_no "Continue uninstalling Launchpad shortcuts?" N; then return 0; fi
  local commands_file="$INSTALL_DIR/config/commands.txt" command rc
  while IFS= read -r command; do
    [ -n "$command" ] || continue
    [ -L "$HOME/bin/$command" ] && rm -f "$HOME/bin/$command"
  done < "$commands_file"
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    if has python || has python3; then
      py="python"
      has python || py="python3"
      "$py" - "$rc" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
start='# >>> TERMUX LAUNCHPAD PATH >>>'; end='# <<< TERMUX LAUNCHPAD PATH <<<'
while start in s and end in s:
    a=s.index(start); b=s.index(end,a)+len(end); s=s[:a]+s[b:]
p.write_text(s)
PY
    else
      sed -i '/^# >>> TERMUX LAUNCHPAD PATH >>>$/,/^# <<< TERMUX LAUNCHPAD PATH <<<$/{d;}' "$rc"
    fi
  done
  say "Shortcuts removed. Restart Termux. Install folder left at $INSTALL_DIR for manual review/removal."
}

