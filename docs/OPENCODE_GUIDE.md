# OpenCode guide

OpenCode is an AI coding agent for the terminal. It needs a configured model/provider before useful AI requests can work. Check the [official OpenCode docs](https://docs.opencode.ai/docs/) for the current installation and configuration options.

## Install in Debian

1. Install Debian from the Launchpad menu.
2. Run `ocinstall` in Termux and confirm the official installer.
3. Check with `ocversion`.
4. Run `linux` or `oc` to start OpenCode.

The launcher uses the official install URL, `https://opencode.ai/install`. You can inspect current instructions before running it. If installation succeeds but the command isn't found, open Debian with `debian`, then check:

```bash
export PATH="$HOME/.opencode/bin:$HOME/.local/bin:$PATH"
opencode --version
```

## Provider setup

OpenCode needs a configured provider or login. You can use its supported providers directly or configure OmniRoute as described in `OMNIROUTE_GUIDE.md`. Do not assume installing OpenCode includes access to a free model or API key.

## Safe use

- Open the intended project directory before asking an agent to modify files.
- Review diffs before accepting broad code changes.
- Keep keys in local configuration and never commit them.
- Keep a Git checkpoint before large AI-assisted refactors.
