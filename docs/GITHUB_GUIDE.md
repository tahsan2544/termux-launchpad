# Git and GitHub basics

Git tracks file changes locally. GitHub hosts repositories online. You can use Git without connecting to GitHub, but `gpush` requires a configured remote and authentication.

## Configure your identity once

Use your preferred values:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Use the email you want associated with your commits. Do not paste access tokens or passwords into these commands.

## Clone a repository

```bash
gclone https://github.com/OWNER/REPOSITORY.git
cd ~/Projects/REPOSITORY
gstatus
```

You can choose a local folder name: `gclone URL MyFolder`.

## Everyday cycle

```bash
gstatus
gdiff
gsave "Describe what changed"
```

`gsave` asks before staging everything, before committing, and before pushing. It is still your responsibility to check for secrets and private files before approving. A `.gitignore` file is useful, but does not automatically untrack a file that was committed previously.

## Remotes and authentication

```bash
gremote
gpush
gpull
```

GitHub may require browser-based login, SSH keys, or a personal access token depending on your setup. Follow GitHub's official authentication docs. Never put a token directly in a remote URL or commit it to a repository.

## Maintainer workflow and automatic versioning

Inside this repository, install the hook once:

```bash
bash scripts/install-git-hooks.sh
```

Every normal commit increments `VERSION` before the commit is created, and the hook stages the new version into that commit. This is intentionally a `pre-commit` hook—not a second automatic commit after every change. Hooks are local to each clone and are not automatically enabled by GitHub after cloning.
