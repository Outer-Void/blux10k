# Installation

BLUX10K is installed via the bundled script: `scripts/install.sh`. The installer copies this repo into
`~/.config/blux10k`, adds a managed block to `~/.zshrc`, and creates a private env file at
`~/.config/private/env.zsh` if one does not exist. Review the script output for any warnings.

## Quickstart (all platforms)

```bash
git clone https://github.com/Outer-Void/blux10k.git
cd blux10k
chmod +x ./scripts/install.sh
./scripts/install.sh
```

The installer logs to `~/.cache/blux10k/logs/` and prints next steps at the end.

## Platform-specific notes

### Debian/Ubuntu (normal host)

1. Ensure `git`, `zsh`, and `curl` are available.
2. Run the installer from the repo root.
3. If the installer cannot change your default shell automatically, run:
   ```bash
   chsh -s "$(command -v zsh)"
   ```
4. Restart your terminal.

### Debian/Ubuntu in proot (including Termux + proot)

1. Enter your proot container and install `git` + `zsh`.
2. Run the installer from inside the container.
3. Fonts are installed to:
   ```text
   ${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k
   ```
4. If `fc-cache` is not available, install `fontconfig` in the container or rebuild the cache later.

### Termux (host)

Termux does not support system-wide font installation. The main installer will skip fonts and
print guidance.

Optional font application for Termux only:

```bash
./fonts/install-fonts.sh --termux-apply
```

This copies the bundled MesloLGS font to `~/.termux/font.ttf`. Restart Termux afterward.

### macOS

1. Ensure `git` and `zsh` are available.
2. Run the installer from the repo root.
3. Fonts are installed into `~/Library/Fonts`. Set your terminal font to “MesloLGS NF”.
4. Restart your terminal session.

## Optional environment flags

The installer honors a few environment flags:

- `BLUX10K_SKIP_FONTS=1` — skip font installation.
- `BLUX10K_VERBOSE=1` / `BLUX10K_DEBUG=1` — increase output.

Use them like:

```bash
BLUX10K_SKIP_FONTS=1 ./scripts/install.sh
```
