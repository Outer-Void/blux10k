# BLUX10K - Professional Developer Terminal Setup

A comprehensive, cross-platform terminal environment designed for modern development workflows.

## Features

- **Cross-Platform**: Works on Linux, macOS, WSL, and Termux
- **Performance Optimized**: Fast startup and responsive interface
- **Modern Tools**: Includes fzf, bat, eza, zoxide, and more
- **Plugin Management**: Uses zplug for efficient plugin loading
- **Powerful Prompt**: Powerlevel10k with custom configuration
- **Private Environment**: Secure handling of API keys and sensitive data
- **Update System**: Comprehensive update function for all components

## Quick Install

```bash
git clone https://github.com/Justadudeinspace/blux10k.git
cd blux10k
chmod +x install.sh
./install.sh
```

## Manual Installation

1. Clone the repository
2. Run the installer
3. Set terminal font to "MesloLGS NF"
4. Restart your terminal

## Configuration

The setup includes:
```
· Custom .zshrc with performance optimizations
· Powerlevel10k prompt configuration
· Neofetch system information display
· Private environment for sensitive data
· Platform-specific optimizations
```
## Usage
```
· update - Update system packages and tools
· b10k update --dry-run - Preview update actions
· b10k doctor - Validate your BLUX10K installation
· mkcd <dir> - Create directory and cd into it
· killport <port> - Kill process on specified port
· extract <archive> - Extract various archive formats
· rz - Reload zsh configuration
```

## Update & Doctor

Run updates safely with explicit phases and backups:

```bash
b10k update
b10k update --dry-run
b10k update --offline
```

Validate your installation and diagnose common issues:

```bash
b10k doctor
```

## Supported Platforms

- Linux (Debian/Ubuntu, Arch, Fedora, Alpine, etc.)
- macOS (Homebrew)
- WSL1/WSL2
- Termux (Android)
- Windows Native (PowerShell + Oh My Posh)

## Troubleshooting

- Run `b10k doctor` to diagnose common issues.
- See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for details.
## License

MIT License - see [LICENSE](./LICENSE) file for details
