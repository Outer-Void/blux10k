<p align="center">
  <img src="docs/assets/blux10k.png" alt="BLUX10K" width="600">
</p>

# BLUX10K v4.0.0 (Stable)

BLUX10K is a curated Zsh setup with an installer, bundled fonts, and ready-to-use configuration
files for Starship and Neofetch. It is **not** a full dotfiles framework or a plugin manager; it
provides a focused, documented baseline that you can customize.

## Quickstart

```bash
git clone https://github.com/Outer-Void/blux10k.git
cd blux10k
chmod +x ./install.sh
./install.sh
```

The installer copies this repo into `~/.config/blux10k`, adds a managed block to `~/.zshrc`, and
creates `~/.config/private/env.zsh` if it doesn’t exist.

During installation you will choose a prompt engine (Powerlevel10k or Starship). To change it
later, re-run the installer with `--prompt=p10k` or `--prompt=starship`.

## Fonts

Install bundled fonts with:

```bash
./fonts/install-fonts.sh
```

- Linux/proot: installs into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/blux10k/`.
- macOS: installs into `~/Library/Fonts/BLUX10K/`.
- Termux: run `./fonts/install-fonts.sh --termux-apply` to set `~/.termux/font.ttf`.

Set your terminal font to “MesloLGS NF” afterward.

## Configuration locations

- Private environment: `~/.config/private/env.zsh` (template in `configs/env.zsh.example`)
- Starship config: `~/.config/starship.toml` (from `configs/starship.toml`)
- Neofetch config: `~/.config/neofetch/config.conf` (from `configs/b10k.neofetch.conf`)

See the docs for details:

- [Installation](docs/INSTALLATION.md)
- [Configuration](docs/CONFIGURATION.md)
- [Customization](docs/CUSTOMIZATION.md)
- [Platforms](docs/PLATFORMS.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## Platform notes

BLUX10K supports Linux, macOS, and Termux. Termux requires manual font application and may not be
able to change the default shell. See [Platforms](docs/PLATFORMS.md).

On Debian/Ubuntu, the installer uses `eza` (replacement for `exa`) and installs `bottom` as the
`btm` package.

## Tests

1. Run `./install.sh --profile` and verify the platform detection output.
2. Run the installer and confirm it completes without errors.
3. Verify `~/.config/starship.toml` is deployed from `configs/starship.toml`.
4. Confirm `~/.zshrc` contains the BLUX10K prompt block.
5. Verify config deploy:
   - After a dry run is not enough, but minimally ensure logic exists and paths are correct.
6. Ensure the zshrc activation block is guarded and idempotent:
   - Running installer twice must not duplicate the BLUX10K NEOFETCH block.

## License

MIT License — see [LICENSE](./LICENSE).
