# Security

## Reporting vulnerabilities

If you discover a security issue, please open an issue with a clear description of the impact and
steps to reproduce. If a private report is needed, include “SECURITY” in the issue title so it can
be handled discreetly.

## Safe usage guidance

- **Private environment file**: Store secrets in `~/.config/private/env.zsh` and keep the file
  permissions restricted (`chmod 600 ~/.config/private/env.zsh`).
- **Least privilege**: Avoid running the installer as root unless absolutely necessary. The
  installer is designed for per-user setup.
- **Backups**: The installer attempts to back up existing BLUX10K directories. Still, keep your
  own backups of personal dotfiles before running any setup scripts.
- **Review before running**: `scripts/install.sh` and `fonts/install-fonts.sh` are shell scripts.
  Review them before execution, especially in production environments.
