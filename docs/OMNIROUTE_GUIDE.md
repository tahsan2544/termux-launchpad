# OmniRoute guide for Termux + OpenCode

[OmniRoute](https://github.com/diegosouzapw/OmniRoute) is a local API router for compatible coding clients. The upstream project documents a Termux installation and a dashboard/API on `http://localhost:20128`.

## Install and start

```bash
omniinstall
omni
```

The `omni` command runs in the foreground; keep that Termux session running and open `omniweb` in Android's browser. To run it in the background instead, use `omnibg`. Check it with `omnistatus`, view logs under `~/.termux-launchpad/logs/omniroute.log`, and stop the Launchpad-managed background process with `omnistop`.

If installation fails due to native dependencies, follow the latest OmniRoute Termux guide from upstream. Node.js support requirements can change; check `node --version` and `npm --version`.

## Connect a provider

1. Open `http://localhost:20128` on the same phone.
2. Complete OmniRoute's setup and connect a provider that you are authorized to use.
3. Use the Dashboard/Endpoints area to obtain an API key for the local API.
4. Keep the API key private.
5. Run `omniconnect` in Termux, confirm the configuration change, and enter the key when prompted. It configures OpenCode inside Debian to use `http://127.0.0.1:20128/v1`, backs up a valid pre-existing `opencode.json`, and makes `omniroute/auto` the configured default model.
6. Ensure OmniRoute is running, then launch OpenCode using `linux`.

The configuration helper expects valid JSON in `~/.config/opencode/opencode.json`. If the file uses JSONC comments or is invalid JSON, the helper deliberately refuses to overwrite it; manually back it up/convert it and retry.

## Privacy and local network safety

- The API key is saved in OpenCode's local config with restrictive file permissions, but it is still a secret. Do not upload that config or include it in an issue/screenshot.
- Default to `localhost`. Do not expose the router to the wider network unless you know how to enable authentication and protect its endpoints.
- Provider terms, quotas, prices, and free tiers vary. OmniRoute does not guarantee all models are free, unlimited, or available in every region.
- If you use remote or third-party providers, prompts and code may leave your phone to be processed by that provider. Check the provider's privacy/retention terms.

## Troubleshooting

```bash
node --version
npm --version
omnistatus
curl -I --max-time 3 http://127.0.0.1:20128/
```

Read the [upstream Termux guide](https://github.com/diegosouzapw/OmniRoute) when commands/options change. Do not use random third-party install commands as a substitute for the project's official instructions.
