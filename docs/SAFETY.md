# Safety and privacy checklist

- Keep API keys, passwords, private SSH keys, `.env` files, provider tokens, and personal data out of Git.
- Do not post `~/.config/opencode/opencode.json` publicly after `omniconnect` is run; it stores the OmniRoute API key.
- OmniRoute should stay bound to local access unless you deliberately configure and secure remote access.
- Read `gsave` prompts. It stages all changes, so inspect `git status` and `git diff` before approving.
- Review AI-generated code before running it. Be careful with shell commands that delete or overwrite files.
- Make backups before large changes: `backup ProjectName`.
- This tool does not root Android. It cannot bypass Android app sandboxing, battery management, or storage restrictions.
- No installer can guarantee 100% success on every Android version, CPU architecture, mirror, and storage state. Keep error messages when reporting issues.
