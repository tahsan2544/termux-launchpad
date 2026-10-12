# Troubleshooting checklist

Start with `lpdoctor` and `dashboard`. Run the exact failing command again only after checking the listed cause.

## `command not found`

- Close and reopen Termux.
- Run `source ~/.bashrc`.
- Run `ls -l ~/bin` and check that `~/bin` is in `echo "$PATH"`.
- Re-run `bash ~/.termux-launchpad/scripts/install-shortcuts.sh` if you deleted shortcuts.

## `pkg` fails to download packages

Check the internet connection and Termux source. Run `termux-change-repo` if a mirror is unavailable, then `pkg update`. Do not add random package repositories from guides you do not trust.

## Debian does not start

```bash
proot-distro list
dstatus
```

Make sure there is enough free storage. Review the exact PRoot-Distro message. Avoid removing or resetting Debian unless you have backed up files inside it.

## OpenCode not found

Run `ocversion`. If missing, install Debian first and run `ocinstall`. Inside Debian, check `command -v opencode` and add `$HOME/.opencode/bin` to PATH for the current session if needed.

## OmniRoute not found or installation fails

```bash
node --version
npm --version
omniinstall
```

Check the current Node.js support range and install requirements in OmniRoute's upstream Termux guide. Native dependencies can fail when a compatible compiler/build toolchain or enough storage is missing.

## OmniRoute dashboard is unavailable

Run `omni` in the foreground to see startup errors. Or check `~/.termux-launchpad/logs/omniroute.log` when started with `omnibg`. Use `omnistatus`. Another process may already use port 20128.

## `omniconnect` refuses the current config

It deliberately refuses to replace an invalid or JSONC config with an incomplete edit. Back up `~/.config/opencode/opencode.json` inside Debian, make it valid plain JSON, then run `omniconnect` again. The helper writes the API key in that file; never commit it.

## Git push fails

Run `gstatus` and `gremote`; verify the remote URL and authentication using GitHub's official docs. Avoid putting tokens in shell history or remote URLs. If `gpull` stops because it is not a fast-forward, inspect the branch before deciding how to reconcile it.

## Version number does not increment

From the repository root, run:

```bash
bash scripts/install-git-hooks.sh
git config core.hooksPath
cat VERSION
```

Expected hooks path is `.githooks`. If you use `git commit --no-verify`, the hook is skipped. Hooks do not run on GitHub's web editor; this automation is for commits created in the local checkout.
