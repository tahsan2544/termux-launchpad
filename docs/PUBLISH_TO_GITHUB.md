# Publish Termux Launchpad to GitHub

This guide is for the person maintaining this repository. It does not publish anything automatically.

## Option A — publish from Termux or a Linux computer

1. Create an **empty** GitHub repository named `termux-launchpad`. For the simplest first push, do not initialize it with a README, license, or `.gitignore` because those files already exist here.
2. Open a terminal in the `termux-launchpad` project directory.
3. Set your Git identity if you have not already done so:

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

4. Initialize and create the first commit at version `1.00`:

   ```bash
   git init -b main
   git add -A
   TERMUX_LAUNCHPAD_SKIP_VERSION_BUMP=1 git commit -m "Initial release 1.00"
   ```

5. Enable automatic version bumps for future commits:

   ```bash
   bash scripts/install-git-hooks.sh
   ```

6. Add your own repository URL and push:

   ```bash
   git remote add origin https://github.com/YOUR_GITHUB_NAME/termux-launchpad.git
   git push -u origin main
   ```

Replace `YOUR_GITHUB_NAME`. GitHub authentication may open a browser or require an approved credential method. Do not put access tokens into the remote URL or source files.

## Option B — upload using the GitHub website

You can create the repository and use **Add file → Upload files** to upload the project files from the extracted ZIP. Git hooks do not run for files committed from GitHub's website. To get automatic local version bumps later, clone the repository to a terminal, install the hooks with `bash scripts/install-git-hooks.sh`, and make future commits locally.

## Verify the version hook

After the initial commit and hook installation, make a harmless edit and commit it:

```bash
echo "Version hook smoke test" >> CONTRIBUTING.md
git add CONTRIBUTING.md
git commit -m "Test automatic version bump"
cat VERSION
git show HEAD:VERSION
```

The commit should include `VERSION` as `1.01`. Remove the smoke-test line in a later commit if you do not want to keep it. Every normal local commit after this should increment the version again. The hook can be bypassed with `git commit --no-verify`, so avoid that option during normal work.
