#!/usr/bin/env bash
set -euo pipefail
if [ -x "$HOME/bin/uninstall-launchpad" ]; then
  exec "$HOME/bin/uninstall-launchpad"
fi
cat <<'MSG'
Launchpad shortcuts are not installed in ~/bin, or the shortcut is missing.
If the repository is installed at ~/.termux-launchpad, run:
  bash ~/.termux-launchpad/scripts/install-shortcuts.sh
Then run `uninstall-launchpad` and confirm the prompt.
No project, backup, Debian, OpenCode, or OmniRoute data was removed.
MSG
