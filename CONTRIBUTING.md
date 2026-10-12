# Contributing

Thanks for helping make Termux Launchpad clearer and safer for beginners.

## Before changing code

- Read `README.md`, `docs/SAFETY.md`, and the guide related to your change.
- Prefer small, reversible changes. Avoid destructive defaults and do not store credentials in the repository.
- Keep shortcuts documented in `config/commands.txt`, `docs/COMMANDS.md`, and `bin/launchpad` in sync.
- Verify links and install commands against upstream documentation before changing them.

## Local checks

```bash
bash scripts/self-test.sh
```

If available, run ShellCheck:

```bash
shellcheck scripts/*.sh bin/launchpad .githooks/pre-commit tests/*.sh
```

## Version hook

After making the initial commit, run `bash scripts/install-git-hooks.sh`. The hook increments `VERSION` and stages it during each normal local commit. Do not manually bump the file for ordinary commits unless you know why.

## Pull requests

Explain the user problem, the change, manual test steps, and any platform limitation. Do not attach logs that contain tokens, private file paths you do not wish to share, or private source code.
