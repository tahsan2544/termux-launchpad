# Termux basics

Termux is an Android terminal environment. It is not the same as a full Debian installation, but it can run Linux command-line tools built for Android.

## Package commands

```bash
pkg update          # refresh package metadata
pkg upgrade         # upgrade installed packages
pkg install git     # install Git
pkg list-installed  # list installed packages
```

Launchpad's `update` shortcut runs `pkg update && pkg upgrade`.

## Files and folders

```bash
pwd                 # current folder
ls -lah             # list files, including hidden ones
cd ~/Projects       # go to your project workspace
mkdir Demo          # create a folder
cp a.txt b.txt      # copy a file
mv old.txt new.txt  # rename/move a file
rm file.txt         # delete a file; check the path before running
```

`~` means your Termux home directory. Launchpad's active project directory is `~/Projects`.

## Android shared storage

Run `termux-setup-storage` once and grant Android's permission if you want files to be visible in the Android file manager. Shared files are usually exposed through `~/storage/shared`. Permission and symlink support differ from Termux's private home directory; do active development in `~/Projects` and export/share copies when needed.

## Copy-paste habits

- Check the folder with `pwd` before deleting, moving, or cloning.
- Avoid commands you do not understand, especially `rm -rf`, `curl ... | sh`, and commands copied from strangers.
- Do not run a command with `sudo` in Termux; it is not a normal root Linux environment.
