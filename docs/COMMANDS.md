# Command reference

All Launchpad commands are optional convenience shortcuts. Their underlying tools can also be run directly.

## Launchpad and health

| Command | Details |
|---|---|
| `launchpad` | Interactive menu for beginners |
| `helpme` | List shortcut commands |
| `dashboard` | Quick summary of project count, storage, Git, Node.js, Debian, OpenCode, and OmniRoute |
| `lpdoctor` | Basic non-destructive diagnostics |
| `lpversion` | Read the installed `VERSION` file |
| `lpupdate` | `git pull --ff-only` only when installed from a Git checkout |
| `uninstall-launchpad` | Remove Launchpad command symlinks and its managed PATH entry |

## Linux and AI tools

| Command | Details |
|---|---|
| `debian` | Start a Debian shell |
| `linux` / `oc` | Start OpenCode inside Debian, using the current Termux-home directory when possible |
| `ocinstall` | Ask before installing OpenCode through the official installer |
| `ocversion` | Print OpenCode version from Debian |
| `omniinstall` | Install OmniRoute with npm in Termux |
| `omni` | Run OmniRoute in foreground; Ctrl+C stops this foreground process |
| `omnibg` | Start OmniRoute in background and write its PID/log to Launchpad's private directory |
| `omnistop` | Stop the PID recorded by Launchpad (does not `pkill` every matching process) |
| `omnistatus` | Probe the local dashboard at port 20128 |
| `omniweb` | Open or print the dashboard URL |
| `omniconnect` | Ask for a local API key and configure OpenCode's Debian-side OmniRoute provider |

## Projects and backups

| Command | Details |
|---|---|
| `projects` | Start a shell in `~/Projects` |
| `sharedprojects` | Open Android shared `Projects` folder |
| `newproject My App` | Create `~/Projects/My App` and a README |
| `project My App` | Start OpenCode with that project as its working directory |
| `projectlist` | List project directories |
| `backup My App` | Tarball the project under `~/ProjectBackups`; omits common large generated folders |

Project names may contain spaces. They cannot contain path separators or `..`. Active Git repositories belong in `~/Projects` because Android shared storage does not fully support Unix file permissions and symlinks.

## Git shortcuts

| Command | Details |
|---|---|
| `gclone URL [FOLDER]` | Clone to `~/Projects` |
| `gstatus` | Show branch and working tree status |
| `glog` | Show the last 10 commits |
| `gdiff` | Show unstaged changes |
| `gremote` | Show Git remotes |
| `gsave MESSAGE` | Display status, then ask before staging all files, committing, and optionally pushing |
| `gpush` | Push the current branch to its configured remote |
| `gpull` | Pull using fast-forward only to avoid creating an accidental merge commit |

## Package management

| Command | Details |
|---|---|
| `update` | Update Termux packages interactively |
| `dupdate` | Refresh Debian package lists |
| `dupgrade` | Upgrade Debian packages interactively |
| `dstatus` | Show PRoot-Distro list and check Debian/OpenCode availability |

Package updates may display prompts; read them rather than blindly accepting unfamiliar changes.
