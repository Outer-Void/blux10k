# ~/.profile: executed by the command interpreter for login shells.

# Include .bashrc when running bash.
if [ -n "${BASH_VERSION:-}" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# User-local bin paths.
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# Optional Rust environment.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Local machine-specific overrides (untracked).
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"
