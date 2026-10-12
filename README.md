# 🚀 Termux Launchpad

### 📱 Turn a fresh Termux install into a beginner-friendly coding workstation.

**Termux • Debian • OpenCode • OmniRoute • GitHub • Project tools**

> 🏷️ **Version:** `1.00` · 🆓 **Open source** · 🔓 **No root required**

Termux Launchpad gives you a simple menu, useful commands, guided setup, and beginner-friendly docs. Install only the tools you want—Debian, OpenCode, and OmniRoute are optional.

---

## ✨ What you get

- 🧭 **Beginner menu** — setup steps, help, dashboard, and diagnostics.
- 🐧 **Debian Linux** — run a Debian userland with PRoot-Distro; no root needed.
- 🤖 **OpenCode** — optional AI coding agent inside Debian.
- 🔀 **OmniRoute** — optional local AI provider router in Termux.
- 🗂️ **Project tools** — create, open, list, and back up projects.
- 🐙 **Git shortcuts** — clone, inspect, commit, pull, and push repositories.
- 🩺 **Troubleshooting** — checks, guides, tests, and GitHub issue templates.
- 🔢 **Version automator** — bumps `VERSION` on normal local commits after setup.

## ⚡ Quick start

### 1️⃣ Update Termux

```bash
pkg update && pkg upgrade -y
pkg install -y git
```

### 2️⃣ Download the project

```bash
git clone https://github.com/tahsan2544/termux-launchpad.git "$HOME/.termux-launchpad"
cd "$HOME/.termux-launchpad"
```

### 3️⃣ Install and launch

```bash
bash install.sh
launchpad
```

Follow the on-screen menu. Start with the basics; install Debian, OpenCode, or OmniRoute only if you need them.

> 💡 If you installed from a ZIP, extract it first, then run `bash install.sh` from the extracted project folder.

---

## 🎮 Most useful commands

| Command | What it does |
|---|---|
| `launchpad` | 🧭 Open the beginner menu |
| `helpme` | 📖 Show available shortcuts |
| `dashboard` | 📊 Check tools and storage |
| `lpdoctor` | 🩺 Diagnose common issues |
| `linux` or `oc` | 🤖 Launch OpenCode inside Debian |
| `debian` | 🐧 Open a Debian shell |
| `ocinstall` / `ocversion` | 📦 Install/check OpenCode |
| `omniinstall` | 🔀 Install OmniRoute |
| `omniweb` | 🌐 Open the local OmniRoute dashboard |
| `projects` | 🗂️ Open your project workspace |
| `newproject NAME` | ➕ Create a project |
| `project NAME` | 🚀 Open a project in OpenCode |
| `projectlist` | 📋 List projects |
| `backup NAME` | 🧰 Back up a project |
| `gclone URL` | 🐙 Clone a Git repository |
| `gstatus` / `glog` / `gdiff` | 🔍 Inspect Git changes/history |
| `gsave "message"` | 💾 Guided commit/push workflow |
| `gpush` / `gpull` | ⬆️ Push / ⬇️ fast-forward pull |
| `update` / `dupdate` / `dupgrade` | 🔄 Update Termux / Debian |
| `lpversion` | 🏷️ Show Launchpad version |
| `lpupdate` | ♻️ Update a Git-based install |

📚 **Full list:** [`docs/COMMANDS.md`](docs/COMMANDS.md)

---

## 🔢 Enable automatic version bumps

The version hook changes `VERSION` on each normal **local Git commit** and includes the new version in that commit: `1.00 → 1.01 → 1.02` … `1.99 → 2.00`.

Run this **once from the repository folder**:

```bash
bash scripts/install-git-hooks.sh
```

Check it is enabled:

```bash
git config --get core.hooksPath
cat VERSION
```

Expected hook path: `.githooks`.

> ⚠️ Git hooks run on your device—not on GitHub's website. They can be bypassed with `git commit --no-verify`; avoid that for normal commits. To manually bump the version, run `bash scripts/bump-version.sh` and then commit the changed `VERSION` file.

---

## 📁 Where things live

- 💻 **Active projects:** `~/Projects`
- 🧰 **Backups:** `~/ProjectBackups`
- ⚙️ **Launchpad files:** `~/.termux-launchpad`
- 📚 **Guides:** [`docs/`](docs/)

> 💡 Use `~/Projects` for active coding and Git repositories. Android shared storage is handy for file-manager access, but can have permission and symlink limitations.

## 🛡️ Safety notes

- 🚫 Root access is not required.
- 🧩 Debian, OpenCode, and OmniRoute are optional; large tools are not installed all at once.
- 🔑 Never commit API keys, passwords, access tokens, or private configuration.
- 🌐 Keep OmniRoute's dashboard local unless you understand how to secure remote access.
- 💸 A router does not guarantee free or unlimited model access; provider accounts and charges may apply.

Read [`docs/SAFETY.md`](docs/SAFETY.md) and [`SECURITY.md`](SECURITY.md) before sharing configurations or reporting issues.

## 🧯 Need help?

1. Run `helpme`, `dashboard`, and `lpdoctor`.
2. Read [`docs/START_HERE.md`](docs/START_HERE.md) and [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md).
3. If you open a GitHub issue, include the exact command and error—but **remove secrets first**.

## 🤝 Contribute

Issues and pull requests are welcome! Start with [`CONTRIBUTING.md`](CONTRIBUTING.md). See [`CHANGELOG.md`](CHANGELOG.md) for project changes.

## 📄 License

MIT — see [`LICENSE`](LICENSE).

---

⭐ If this project helps you, consider starring the repository and sharing it with another Termux beginner.
