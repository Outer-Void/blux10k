# Troubleshooting

## Installer ran but the shell didn’t switch

The installer attempts to set Zsh as your default shell, but this can fail in some environments.
Run the following manually and restart your terminal:

```bash
chsh -s "$(command -v zsh)"
```

If `chsh` fails (common in containers or Termux), start Zsh manually: `zsh`.

## Prompt is not showing

1. Ensure the BLUX10K entrypoint exists:
   ```bash
   ls ~/.config/blux10k/blux10k.zsh
   ```
2. Confirm your `~/.zshrc` includes a BLUX10K block between:
   ```text
   # >>> BLUX10K START
   # <<< BLUX10K END
   ```
3. Re-run `./scripts/install.sh` from the repo root if either is missing.

## Starship isn’t loading

- Ensure Starship is installed (`starship --version`).
- Re-run the installer with `--prompt=starship`.
- Confirm `~/.zshrc` includes `eval "$(starship init zsh)"`, then restart your shell.

## Fonts installed but terminal doesn’t show them

1. Set your terminal font to “MesloLGS NF” (or another bundled font).
2. On Linux/proot, rebuild the font cache if needed:
   ```bash
   fc-cache -f
   ```
3. Restart the terminal application.

## Termux font application

Termux requires a manual font apply step:

```bash
./fonts/install-fonts.sh --termux-apply
```

Then restart Termux.

## PATH or permission issues

- Ensure the installer ran from the repo root.
- Check the installer log at `~/.cache/blux10k/logs/` for errors.
- Verify your private env file permissions:
  ```bash
  chmod 600 ~/.config/private/env.zsh
  ```
