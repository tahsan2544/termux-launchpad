# Termux Launchpad

**A beginner-friendly workstation starter for Termux, Debian, OpenCode, OmniRoute, projects, and GitHub.**

Termux Launchpad is a collection of small scripts and guides—not a mystery mega-command. It gives a first-time Termux user a menu, sensible shortcuts, setup checks, project folders, backups, and optional AI coding tools.

> **Current version:** see [`VERSION`](VERSION). The project begins at `1.00`.

## What it does

- Installs common Termux tools and creates a beginner menu.
- Can install Debian through PRoot-Distro without rooting Android.
- Can install OpenCode inside Debian using the official installer.
- Can install OmniRoute natively in Termux and open its local dashboard.
- Adds shell shortcuts for projects, backups, Git, status checks, updates, and troubleshooting.
- Includes written guides, issue templates, security notes, tests, and GitHub Actions.
- Includes a local Git hook that bumps `VERSION` from `1.00` to `1.01` as part of each normal commit after the hook is installed.

## Requirements

- Android with Termux installed from an official source.
- An internet connection for installation and updates.
- Enough free phone storage for whichever components you choose. Debian and AI tools can take a substantial amount of space.
- No root access is required.

Use a current Termux app from [Termux GitHub releases](https://github.com/termux/termux-app/releases) or [F-Droid](https://f-droid.org/packages/com.termux/). Do not mix Termux and its add-ons from incompatible distribution sources.

## First-time installation

### 1. Update Termux and install Git

Open Termux and run:

```bash
pkg update && pkg upgrade -y
pkg install -y git
```

### 2. Clone this repository

After you publish the repository, replace `YOUR_GITHUB_NAME` below with your GitHub username (or organization):

```bash
git clone https://github.com/YOUR_GITHUB_NAME/termux-launchpad.git "$HOME/.termux-launchpad"
cd "$HOME/.termux-launchpad"
bash install.sh
```

Clone directly into `~/.termux-launchpad` if you want `lpupdate` to update this Git checkout later. If you downloaded a ZIP, extract it and run its `install.sh`; the installer copies runtime files into `~/.termux-launchpad`.

### 3. Follow the menu

When asked, allow Android shared-storage access and install recommended base packages. Then run:

```bash
launchpad
```

Choose **Install Debian Linux** first if you want a Debian shell, then **Install OpenCode inside Debian**. OmniRoute is optional and installs natively in Termux.

If a newly installed command is not found, close and reopen Termux or run:

```bash
source ~/.bashrc
helpme
```

## Quick command guide

| Command | What it does |
|---|---|
| `launchpad` | Interactive beginner menu |
| `helpme` | Show all shortcuts |
| `dashboard` | Show projects, disk space, Node.js, Debian, OpenCode, and OmniRoute status |
| `lpdoctor` | Diagnose common installation problems |
| `linux` or `oc` | Start OpenCode inside Debian when installed |
| `debian` | Open a Debian shell |
| `ocinstall` / `ocversion` | Install/check OpenCode inside Debian |
| `omniinstall` | Install OmniRoute inside Termux |
| `omni` | Run OmniRoute in the foreground |
| `omnibg` / `omnistop` | Start/stop the background OmniRoute process managed by Launchpad |
| `omnistatus` / `omniweb` | Check/open the local OmniRoute dashboard |
| `omniconnect` | Configure Debian OpenCode to use the local OmniRoute endpoint |
| `projects` | Open `~/Projects` (recommended active coding location) |
| `sharedprojects` | Open `Internal storage/Projects` from Android shared storage |
| `newproject NAME` | Create a project; names may contain spaces |
| `project NAME` | Open a project in OpenCode inside Debian |
| `projectlist` | List projects |
| `backup NAME` | Create a compressed project backup under `~/ProjectBackups` |
| `gclone URL [NAME]` | Clone a Git repository into `~/Projects` |
| `gstatus`, `glog`, `gdiff`, `gremote` | Common Git inspection commands |
| `gsave MESSAGE` | Review changes, then optionally stage, commit, and push |
| `gpush` / `gpull` | Push / fast-forward pull |
| `update` | Update Termux packages |
| `dupdate` / `dupgrade` | Update Debian package lists / upgrade packages |
| `dstatus` | Show Debian and OpenCode status |
| `lpversion` | Show Launchpad version |
| `lpupdate` | Update only when installed from a Git checkout |
| `uninstall-launchpad` | Remove Launchpad shortcuts (not Debian or your projects) |

## Where your files live

- **Active projects:** `~/Projects` — recommended for Git, code, symlinks, and executable files.
- **Backups:** `~/ProjectBackups`.
- **Android-shared projects:** `~/storage/shared/Projects` (usually visible as `Internal storage/Projects`).
- **Launchpad runtime and logs:** `~/.termux-launchpad` and `~/.termux-launchpad/logs`.

Android shared storage is useful for file-manager access, but it has permission and symlink limitations. Use `~/Projects` for active coding repositories; copy/export files to shared storage when you need to access them from other Android apps.

## OpenCode + OmniRoute overview

- OpenCode runs inside the Debian userland.
- OmniRoute runs in Termux and uses its local dashboard/API at `http://localhost:20128`.
- Once OmniRoute is installed, run `omni` or `omnibg`; open `omniweb` to connect a provider and obtain the API key.
- Run `omniconnect` to add a basic OmniRoute provider to OpenCode's Debian config. The command backs up existing valid JSON config first, asks for the key without echoing it, and stores the resulting config with restrictive file permissions.
- The API key is a secret. Never paste it into a GitHub issue, public chat, screenshot, source file, or commit. See [`docs/OMNIROUTE_GUIDE.md`](docs/OMNIROUTE_GUIDE.md).

Some providers require an account, authorization, or paid usage. OmniRoute is a router; it does not guarantee unlimited free model access.

## Version auto-bump on each commit

The version updater uses `.githooks/pre-commit`. Git does not distribute hooks automatically, so a repository maintainer needs to install it once:

```bash
bash scripts/install-git-hooks.sh
```

After that, each normal commit increments `VERSION` and stages it with the commit. For example, a commit at `1.00` is recorded as `1.01`; after `1.99`, the next version is `2.00`.

**Why pre-commit?** A Git commit is immutable after creation. Literally changing a file *after* a commit requires making a second commit or rewriting the first one. This hook ensures the new version is included in the commit that is being created. `git commit --no-verify` can bypass Git hooks; avoid it unless you deliberately need to.

Test the hook locally:

```bash
bash scripts/self-test.sh
bash scripts/install-git-hooks.sh
git status
```

For complete publishing instructions—including keeping the first commit at `1.00`—read [`docs/PUBLISH_TO_GITHUB.md`](docs/PUBLISH_TO_GITHUB.md).

## Safety and scope

- Launchpad does not root the phone or claim that PRoot-Distro is a full virtual machine.
- Debian/OpenCode/OmniRoute are optional; the installer does not install all large components automatically.
- Installing OpenCode downloads and executes the official installation script from `opencode.ai`; inspect upstream instructions if you prefer to install manually.
- OmniRoute's dashboard should stay local unless you intentionally understand and secure remote access.
- `gsave` prompts before staging everything and before committing/pushing. Always review `git status` and `git diff` first.
- `uninstall-launchpad` removes shortcut links and the managed PATH block only. It does not erase Debian, projects, backups, OpenCode, or OmniRoute.

## Updating Launchpad

If cloned to `~/.termux-launchpad`:

```bash
lpupdate
```

Then re-run the installer to update links if new commands were added:

```bash
cd "$HOME/.termux-launchpad"
bash install.sh
```

If you installed from a ZIP (no `.git` directory), download the newest release and run `install.sh` again.

## Troubleshooting

Start with:

```bash
lpdoctor
dashboard
helpme
```

Then read [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md). If the issue persists, open a GitHub issue with the device/Android version, Termux source, exact command, and error output. Never include API keys or private project code.

## Publish this repository

Follow [`docs/PUBLISH_TO_GITHUB.md`](docs/PUBLISH_TO_GITHUB.md) to create the GitHub repository, make the initial `1.00` commit, enable the version hook, and push the code.

## Repository map

```text
bin/launchpad                 Single command dispatcher
lib/                          Modular project, Git, system, and AI-tool functions
config/commands.txt           List of installed shortcut names
scripts/                      Installers, tests, version tooling
.githooks/pre-commit          Automatic version increment hook
docs/                         Beginner guides
.github/                       Issue templates and CI
VERSION                       Current project version
```

## Official references

- [Termux package management](https://github.com/termux/termux-packages/wiki/package-management)
- [PRoot-Distro](https://github.com/termux/proot-distro)
- [OpenCode documentation](https://docs.opencode.ai/docs/)
- [OmniRoute project and setup guide](https://github.com/diegosouzapw/OmniRoute)

## License

MIT. See [`LICENSE`](LICENSE).
