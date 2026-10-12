# Termux Launchpad library: projects

cmd_projects() {
  ensure_projects
  cd "$PROJECTS_DIR" || return 1
  say "Project workspace: $PROJECTS_DIR"
  exec "${SHELL:-/data/data/com.termux/files/usr/bin/bash}" -l
}

cmd_sharedprojects() {
  if [ ! -d "$HOME/storage/shared" ]; then
    warn "Android shared storage is not connected yet. Run: termux-setup-storage"
    return 1
  fi
  mkdir -p "$SHARED_PROJECTS_DIR"
  if has termux-open; then termux-open "$SHARED_PROJECTS_DIR" >/dev/null 2>&1 || true; fi
  cd "$SHARED_PROJECTS_DIR" || return 1
  say "Shared folder: $SHARED_PROJECTS_DIR"
  say "Tip: keep active Git repositories in ~/Projects; Android shared storage has permission and symlink limitations."
  exec "${SHELL:-/data/data/com.termux/files/usr/bin/bash}" -l
}

cmd_newproject() {
  local name path
  name="$(project_name_from_args "$@")" || return 1
  ensure_projects
  path="$PROJECTS_DIR/$name"
  if [ -e "$path" ]; then err "That project already exists: $path"; return 1; fi
  mkdir -p "$path"
  cat > "$path/README.md" <<EOF2
# $name

Created with Termux Launchpad.

## Getting started

Add your project notes, source files, and instructions here.
EOF2
  ok "Created $path"
  say "Open it with: project $name"
}

cmd_project() {
  local name path
  name="$(project_name_from_args "$@")" || return 1
  path="$PROJECTS_DIR/$name"
  [ -d "$path" ] || { err "Project not found: $path. Create it with: newproject $name"; return 1; }
  if ! is_debian_installed; then err "Debian is not installed. Run launchpad and choose Install Debian."; return 1; fi
  exec proot-distro login debian -- bash -lc '
    target="$1"
    shift
    [ -d "$target" ] || { echo "Project path is not visible inside Debian: $target"; exit 2; }
    cd "$target" || exit 2
    export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"
    if command -v opencode >/dev/null 2>&1; then exec opencode "$@"; fi
    echo "OpenCode is not installed in Debian. Run ocinstall from Termux."
    exec bash -l
  ' launchpad-project "$path"
}

cmd_projectlist() {
  ensure_projects
  say "Projects in $PROJECTS_DIR"
  local found=0 entry
  while IFS= read -r -d '' entry; do
    found=1
    printf '  - %s\n' "$(basename "$entry")"
  done < <(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null | sort -z)
  [ "$found" -eq 1 ] || say "  (No projects yet. Try: newproject MyProject)"
}

cmd_backup() {
  local name path stamp archive
  name="$(project_name_from_args "$@")" || return 1
  path="$PROJECTS_DIR/$name"
  [ -d "$path" ] || { err "Project not found: $path"; return 1; }
  mkdir -p "$BACKUPS_DIR"
  stamp="$(date +%Y%m%d-%H%M%S)"
  archive="$BACKUPS_DIR/${name// /_}-$stamp.tar.gz"
  if tar -czf "$archive" --exclude='node_modules' --exclude='.venv' --exclude='dist' --exclude='build' -C "$PROJECTS_DIR" "$name"; then
    ok "Backup created: $archive"
  else
    rm -f "$archive"; err "Backup failed."; return 1
  fi
}

