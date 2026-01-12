# Troubleshooting

## Fonts look wrong

- Ensure **MesloLGS NF** is installed.
- Set your terminal font to MesloLGS NF.
- Run `b10k doctor` to see font guidance.

## `b10k` command not found

- Ensure `~/.local/bin` is in your PATH.
- Re-run `./install.sh` or copy `scripts/b10k` to `~/.local/bin/b10k`.

## Update fails due to network

- Run `b10k update --offline` to skip fetch/pull.
- Retry once the network is available.

## Zsh not the default shell

- Run `chsh -s $(which zsh)` and restart your terminal.
