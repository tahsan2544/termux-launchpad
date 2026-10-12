# Termux Launchpad library: git-tools

cmd_gclone() {
  require_termux || return 1
  if [ "$#" -lt 1 ]; then err "Usage: gclone REPOSITORY_URL [FOLDER_NAME]"; return 1; fi
  local url="$1" name="${2:-}"
  ensure_projects
  if [ -n "$name" ]; then
    name="$(project_name_from_args "$name")" || return 1
    git clone "$url" "$PROJECTS_DIR/$name"
  else
    (cd "$PROJECTS_DIR" && git clone "$url")
  fi
}

current_git_root() {
  git rev-parse --show-toplevel 2>/dev/null
}

cmd_gstatus() { current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }; git status --short --branch; }

cmd_glog() { current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }; git log --oneline --decorate -10; }

cmd_gdiff() { current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }; git diff --; }

cmd_gremote() { current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }; git remote -v; }

cmd_gpush() { current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }; git push; }

cmd_gpull() { current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }; git pull --ff-only; }

cmd_gsave() {
  local message="$*"
  [ -n "$message" ] || { err 'Usage: gsave "Describe your changes"'; return 1; }
  current_git_root >/dev/null || { err "Not inside a Git repository."; return 1; }
  say "Current status:"
  git status --short
  warn "The next step stages all changes. Check for API keys, .env files, passwords and private data first."
  if ! ask_yes_no "Stage all changes and commit with message: $message ?" N; then say "Cancelled."; return 0; fi
  git add -A || return 1
  git diff --cached --stat
  if ! ask_yes_no "Commit the staged changes?" N; then say "Changes remain staged; no commit made."; return 0; fi
  git commit -m "$message" || return 1
  if ask_yes_no "Push the new commit to the configured remote?" N; then git push; fi
}

