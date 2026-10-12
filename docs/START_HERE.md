# Start Here: a friendly first session

You do not need to know Linux already. Do one step at a time and stop whenever a command reports an error.

## Step 1 — install Launchpad

Follow the installation commands in the root [`README.md`](../README.md). The installer adds shortcuts to `~/bin` and adds that folder to your shell's PATH.

## Step 2 — learn the 4 basic commands

```bash
helpme       # read the command list
 dashboard   # view your setup status
projects     # enter your project folder
lpdoctor     # check common problems
```

You can also launch the numbered menu at any time:

```bash
launchpad
```

## Step 3 — create a test project

```bash
newproject FirstProject
projectlist
```

You have now created `~/Projects/FirstProject/README.md`. You can edit it with `nano ~/Projects/FirstProject/README.md` or open it in OpenCode after you have installed Debian and OpenCode.

## Step 4 — add Linux tools only when you need them

Run `launchpad`, select **Install Debian Linux**, then **Install OpenCode inside Debian**. Debian lives inside PRoot-Distro. It does not replace Android or require a rooted phone.

## Step 5 — set up OmniRoute only if you need a local API router

Select the OmniRoute option from the menu or run `omniinstall`. Start it with `omni`, then open the dashboard with `omniweb`. Connect a provider from the OmniRoute dashboard first. The router does not automatically give every model free access.

## The most useful habits

- Read the complete command before pressing Enter.
- Run one command at a time when learning.
- Keep working repositories in `~/Projects`, not Android shared storage.
- Back up important work: `backup FirstProject`.
- Do not commit API keys, `.env` files, passwords, or private data.
- If a command fails, copy the exact error and run `lpdoctor` before reinstalling everything.
