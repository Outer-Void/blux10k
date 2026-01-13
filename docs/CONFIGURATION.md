# Configuration

BLUX10K keeps user-editable configuration in standard XDG locations. The installer writes its
runtime files to `~/.config/blux10k` and will source `~/.config/private/env.zsh` if it exists.

## Private environment (`configs/env.zsh.example`)

Use the template to store personal variables and API keys.

```bash
cp ./configs/env.zsh.example ~/.config/private/env.zsh
chmod 600 ~/.config/private/env.zsh
```

This file is intentionally excluded from version control. Keep secrets commented out until needed.

## Starship prompt (`configs/starship.toml`)

To use the bundled Starship configuration:

```bash
mkdir -p ~/.config
cp ./configs/starship.toml ~/.config/starship.toml
```

Then enable Starship in your shell and set `BLUX10K_USE_STARSHIP=1` before sourcing the BLUX10K
entrypoint (for example, in `~/.config/private/env.zsh`).

## Neofetch configuration (`configs/b10k.neofetch.conf`)

You can run Neofetch directly with the configuration file:

```bash
neofetch --config /path/to/blux10k/configs/b10k.neofetch.conf
```

Or copy it into Neofetch’s default location:

```bash
mkdir -p ~/.config/neofetch
cp ./configs/b10k.neofetch.conf ~/.config/neofetch/config.conf
```
