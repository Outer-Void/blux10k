# blux10k

`blux10k` is a personal shell-environment repository. It stores user dotfiles in `dotfiles/` and provides helper scripts in `scripts/` for setup, backup/restore, validation, syncing, and shell workflow tasks.

## Repository layout

```text
.
├── cp_dotfiles.sh
├── dotfiles/
│   ├── .bashrc
│   ├── .gitconfig
│   ├── .p10k.zsh
│   ├── .profile
│   └── .zshrc
├── scripts/
│   ├── activate_venv.sh
│   ├── backup_dotfiles.sh
│   ├── bootstrap-debian.sh
│   ├── diff_dotfiles.sh
│   ├── doctor.sh
│   ├── ensure_dirs.sh
│   ├── link.sh
│   ├── list_dotfiles.sh
│   ├── py_venv.sh
│   ├── reload_shell.sh
│   ├── restore_dotfiles_backup.sh
│   ├── safe_zip.sh
│   ├── sync_dotfiles.sh
│   ├── unlink.sh
│   └── update_plugins.sh
└── README.md
```

## Setup methods

### A) Preferred setup flow: `cp_dotfiles.sh`

Run from repository root:

```bash
./cp_dotfiles.sh
```

Prompt and action order:

1. `Back up existing managed dotfiles before copy? [y/N]: `
   - If `y`/`Y`, runs `./scripts/backup_dotfiles.sh` before copying.
2. Copy step (always runs):
   - Copies `dotfiles/.` into `$HOME/` using `cp -a`.
3. `Run ./scripts/bootstrap-debian.sh? [y/N]: `
4. `Set zsh as main shell? [y/N]: `
5. `Run ./scripts/ensure_dirs.sh? [y/N]: `
6. `Copy scripts/ dir to $HOME/tools/scripts? [y/N]: `
7. `Run ./scripts/doctor.sh? [y/N]: `
8. `Run ./scripts/list_dotfiles.sh? [y/N]: `
9. `Run ./scripts/diff_dotfiles.sh? [y/N]: `
10. `Run ./scripts/update_plugins.sh? [y/N]: `
11. `Source ~/.zshrc now? [y/N]: `

Notes:
- `cp_dotfiles.sh` intentionally does **not** auto-run destructive/reversal utilities (`restore_dotfiles_backup.sh`, `sync_dotfiles.sh`, `unlink.sh`) and does not auto-run `reload_shell.sh`.
- If a prompted script is missing, the flow prints a message and continues.

### B) Alternative setup flow: `scripts/link.sh`

Run from repository root:

```bash
./scripts/link.sh
```

This is the symlink-based setup option. It links these managed targets (if source exists):

- Files to `$HOME`: `.bashrc`, `.profile`, `.zshrc`, `.p10k.zsh`, `.gitconfig`
- Directories to `$HOME/.config`: `nvim`, `fastfetch`, `ranger`

`link.sh` uses `ln -sf`/`ln -sfn`, so existing targets at those paths may be replaced by symlinks.

## Script reference

- `scripts/activate_venv.sh`
  - Bash virtualenv activator. Must be **sourced**.
  - Deactivates existing venv, activates `.venv` or `venv` in current directory, validates interpreter paths.

- `scripts/bootstrap-debian.sh`
  - Debian/Ubuntu bootstrap helper using `apt`.
  - Installs terminal/dev packages and clones `~/.zplug` plus `~/powerlevel10k` when missing.

- `scripts/link.sh`
  - Symlink-based dotfiles installer from this repo into `$HOME`.

- `scripts/py_venv.sh`
  - POSIX-shell virtualenv helper. Must be **sourced**.
  - Creates `.venv` if missing, activates it, verifies interpreter resolution.

- `scripts/safe_zip.sh`
  - Creates timestamped zip archives while excluding common sensitive/cache/venv/git paths.

- `scripts/backup_dotfiles.sh`
  - Backs up existing managed tracked targets from `$HOME` into `~/.blux10k_backup/<timestamp>/`.
  - Only backs up paths that correspond to entries currently tracked under `dotfiles/`.

- `scripts/restore_dotfiles_backup.sh`
  - Restores the latest backup from `~/.blux10k_backup/` back into `$HOME`.
  - Keeps backup history in place.

- `scripts/sync_dotfiles.sh`
  - Copies current tracked managed files from `$HOME` back into `dotfiles/`.
  - Sync scope is limited to entries already tracked under `dotfiles/`.

- `scripts/doctor.sh`
  - Read-only environment report for required/common tools and key paths.
  - Reports present/missing status; does not auto-fix.

- `scripts/unlink.sh`
  - Removes only symlinks in `$HOME` that point to this repo’s `dotfiles/` targets used by `link.sh`.
  - Does not delete regular files.

- `scripts/list_dotfiles.sh`
  - Lists all currently managed entries under `dotfiles/` (relative paths).

- `scripts/diff_dotfiles.sh`
  - Compares each tracked `dotfiles/` entry with its corresponding `$HOME` path.
  - Reports: missing in `$HOME`, identical, or different.

- `scripts/reload_shell.sh`
  - Attempts to source `~/.zshrc` or `~/.bashrc` based on detected shell context.
  - For current-session impact, this script should be **sourced** (`source ./scripts/reload_shell.sh`).

- `scripts/ensure_dirs.sh`
  - Ensures expected directories exist: `$HOME/tools`, `$HOME/tools/scripts`, `$HOME/.config`.

- `scripts/update_plugins.sh`
  - Updates optional shell components if present:
    - `~/.zplug` (runs `zplug update` and `zplug install` via `zsh`)
    - `~/powerlevel10k` (runs `git pull --ff-only` if it is a git repo)
  - Missing optional components are reported and skipped.

## Dotfiles reference

Current tracked entries in `dotfiles/`:

- `.bashrc`
- `.gitconfig`
- `.p10k.zsh`
- `.profile`
- `.zshrc`

## Usage notes

- **Copy vs symlink**:
  - `cp_dotfiles.sh` copies files into `$HOME`.
  - `scripts/link.sh` creates symlinks back to the repo.

- **Backups**:
  - `scripts/backup_dotfiles.sh` only stores managed tracked targets that already exist in `$HOME`.
  - `scripts/restore_dotfiles_backup.sh` restores from the latest backup and does not remove backup history.

- **Debian bootstrap assumption**:
  - `scripts/bootstrap-debian.sh` expects a Debian/Ubuntu-like system with `apt` and `sudo`.

- **Virtualenv helpers**:
  - `scripts/activate_venv.sh` and `scripts/py_venv.sh` are intended to be sourced, not executed.

- **Reload behavior**:
  - `scripts/reload_shell.sh` cannot change a parent shell when run as a normal subprocess; source it when you need the current shell session updated.
