#!/usr/bin/env bash
set -euo pipefail
INSTALL_DIR="$HOME/.termux-launchpad"
[ -x "$INSTALL_DIR/bin/launchpad" ] || { echo "Missing $INSTALL_DIR/bin/launchpad. Re-run install.sh." >&2; exit 1; }
mkdir -p "$HOME/bin"
while IFS= read -r name; do
  [ -n "$name" ] || continue
  ln -sfn "$INSTALL_DIR/bin/launchpad" "$HOME/bin/$name"
done < "$INSTALL_DIR/config/commands.txt"

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ "$rc" = "$HOME/.bashrc" ] || [ -f "$rc" ]; then
    touch "$rc"
    if ! grep -qF '# >>> TERMUX LAUNCHPAD PATH >>>' "$rc"; then
      cat >> "$rc" <<'BLOCK'

# >>> TERMUX LAUNCHPAD PATH >>>
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
# <<< TERMUX LAUNCHPAD PATH <<<
BLOCK
    fi
  fi
done
chmod +x "$INSTALL_DIR/bin/launchpad"
echo "Installed $(wc -l < "$INSTALL_DIR/config/commands.txt" | tr -d ' ') shortcut commands in ~/bin."
echo "Close and reopen Termux if a new command is not found."
