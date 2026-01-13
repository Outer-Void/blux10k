# Customization

BLUX10K focuses on a clean Zsh setup, optional Starship configuration, and bundled fonts.

## Fonts

Install fonts from the repo with:

```bash
./fonts/install-fonts.sh
```

- Linux/proot: installs into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k/`.
- macOS: installs into `~/Library/Fonts/BLUX10K/`.
- Termux: run `./fonts/install-fonts.sh --termux-apply` to set `~/.termux/font.ttf`.

After installation, set your terminal font to “MesloLGS NF” (or a bundled alternative) and restart
your terminal.

## Prompt selection

The installer defaults to Powerlevel10k if it can be installed. If you prefer Starship:

1. Install Starship (outside of this repo).
2. Copy `configs/starship.toml` to `~/.config/starship.toml`.
3. Set `BLUX10K_USE_STARSHIP=1` in `~/.config/private/env.zsh`.

## Environment variables

Customize BLUX10K behavior in `~/.config/private/env.zsh`. The template at
`configs/env.zsh.example` includes safe defaults and optional entries for API tokens.
