# Installation

## Quick Install

```bash
git clone https://github.com/Justadudeinspace/blux10k.git
cd blux10k
chmod +x install.sh
./install.sh
```

## Options

```bash
./install.sh --platform-only
./install.sh --minimal
./install.sh --skip-fonts
./install.sh --skip-deps
```

## What the installer does

- Detects your platform and package manager.
- Installs core dependencies and optional tooling.
- Deploys configuration files with timestamped backups.
- Records the install location in `~/.config/blux10k/install.conf`.
- Installs the `b10k` command into `~/.local/bin`.

## Update after install

```bash
b10k update
b10k update --dry-run
```
