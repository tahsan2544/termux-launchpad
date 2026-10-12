# Debian in Termux

Launchpad uses [PRoot-Distro](https://github.com/termux/proot-distro) to run Debian's userspace on Android. No root access is required.

## Install

1. Run `launchpad`.
2. Choose **Install Debian Linux**.
3. Confirm the download and wait for it to finish.
4. Use `debian` to open a shell.
5. Use `dstatus` to check whether Debian starts.

Or run the official commands directly:

```bash
pkg install proot-distro
proot-distro install debian
proot-distro login debian
```

Inside Debian, package operations use `apt`, not Termux's `pkg`:

```bash
apt update
apt upgrade
apt install git curl nano python3
```

Launchpad's `dupdate` and `dupgrade` run package commands in Debian.

## Understand the boundary

Termux and Debian have different filesystems and package managers. PRoot-Distro binds some Android/Termux paths into the container, but not every Android app path behaves like an ordinary Linux filesystem. Keep project folders in `~/Projects` under Termux home, and confirm the chosen path is visible inside Debian before using a tool on it.

## Storage and performance

Debian can use significant storage. Android may pause long-running processes to conserve battery, and PRoot-Distro is not a hardware-isolated virtual machine. You may encounter package or native-binary limitations on some devices.

## Remove Debian?

Do not run `proot-distro remove debian` unless you intend to remove that whole Debian installation and its internal files. It is not part of `uninstall-launchpad`.
