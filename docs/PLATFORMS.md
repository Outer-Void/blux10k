# Supported Platforms

BLUX10K targets a broad set of environments. The installer and update system adapt to the following:

- **Linux**: Debian/Ubuntu (apt), Arch (pacman), Fedora (dnf), Alpine (apk), Void (xbps), Gentoo (emerge)
- **macOS**: Homebrew
- **WSL**: WSL1/WSL2 with Linux package manager detection
- **Termux**: `pkg` (Android)
- **Windows Native**: PowerShell + Oh My Posh

If your distro isn't listed, BLUX10K will attempt a generic Linux setup and provide guidance when a package manager isn't detected.
