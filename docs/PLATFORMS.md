# Platforms

BLUX10K targets Zsh environments on Linux, macOS, and Termux. The installer adapts behavior based
on the host platform.

## Support matrix

| Platform | Installer support | Fonts | Notes |
| --- | --- | --- | --- |
| Debian/Ubuntu (host) | ✅ | ✅ | Uses `~/.local/share/fonts/blux10k` and `fc-cache` when available. |
| Debian/Ubuntu (proot) | ✅ | ✅ | Same as Linux; ensure `fontconfig` for `fc-cache` if desired. |
| macOS | ✅ | ✅ | Fonts install into `~/Library/Fonts`. |
| Termux (host) | ✅ | ⚠️ | Fonts require manual apply to `~/.termux/font.ttf`. |

## Known limitations

- Termux does not allow system-wide font installation; use `fonts/install-fonts.sh --termux-apply`.
- Changing the default shell may fail in containerized environments; re-run `chsh` manually if needed.
- Fonts may require a terminal restart after installation.
