# blux10k

`blux10k v2.0` is a stabilized, portable shell environment repository. It ships reusable dotfiles plus bootstrap/maintenance scripts for setup, validation, backup, sync, and symlink-based management.

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
│   ├── check_version.sh
│   ├── link.sh
│   ├── list_dotfiles.sh
│   ├── managed_entries.sh
│   ├── py_venv.sh
│   ├── reload_shell.sh
│   ├── restore_dotfiles_backup.sh
│   ├── safe_zip.sh
│   ├── sync_dotfiles.sh
│   ├── unlink.sh
│   └── update_plugins.sh
├── .gitignore
└── README.md
```

## Setup methods

### A) Preferred guided setup: `./cp_dotfiles.sh`

Run from repository root:

```bash
./cp_dotfiles.sh
```

Prompt flow (in order):

1. Optional backup (`scripts/backup_dotfiles.sh`)
2. Copy `dotfiles/` contents into `$HOME`
3. Optional bootstrap (`scripts/bootstrap-debian.sh`)
4. Optional set zsh as login shell
5. Optional ensure expected directories (`scripts/ensure_dirs.sh`)
6. Optional copy `scripts/` into `$HOME/tools/scripts`
7. Optional environment doctor (`scripts/doctor.sh`)
8. Optional managed-entry listing (`scripts/list_dotfiles.sh`)
9. Optional managed-entry diff (`scripts/diff_dotfiles.sh`)
10. Optional plugin updates (`scripts/update_plugins.sh`)
11. End-of-run reminder to open a new shell or run `zsh`
12. End-of-run reminder to run `p10k configure` manually

`cp_dotfiles.sh` does not source `~/.zshrc` from bash and does not auto-run restore/sync/unlink flows.

### B) Alternative symlink setup: `./scripts/link.sh`

Run from repository root:

```bash
./scripts/link.sh
```

`link.sh` links managed entries from `dotfiles/` (top-level tracked entries) into matching paths under `$HOME`. `unlink.sh` removes only matching symlinks created from this repo.

## Script reference

- `scripts/managed_entries.sh` — canonical managed-entry list (direct children of `dotfiles/`)
- `scripts/backup_dotfiles.sh` — backup managed entries from `$HOME` into `~/.blux10k_backup/<timestamp>/`
- `scripts/restore_dotfiles_backup.sh` — restore latest backup from `~/.blux10k_backup/`
- `scripts/sync_dotfiles.sh` — sync managed entries from `$HOME` back into `dotfiles/` (supports `--dry-run`)
- `scripts/list_dotfiles.sh` — list managed entries
- `scripts/diff_dotfiles.sh` — compare managed entries in `dotfiles/` vs `$HOME`
- `scripts/link.sh` — symlink managed entries into `$HOME`
- `scripts/unlink.sh` — remove matching blux10k-managed symlinks from `$HOME`
- `scripts/bootstrap-debian.sh` — Debian/Ubuntu bootstrap via `apt`, plus zplug/powerlevel10k setup (no inline prompt wizard execution)
- `scripts/update_plugins.sh` — update zplug plugins and powerlevel10k (if installed)
- `scripts/doctor.sh` — non-destructive environment/tooling report
- `scripts/ensure_dirs.sh` — ensure `$HOME/tools`, `$HOME/tools/scripts`, `$HOME/tools/scripts/axiom`, `$HOME/.config`, `$HOME/.config/axiom`, and `$HOME/.config/bluxgpt`
- `scripts/check_version.sh` — semantic-version gate utility for downstream checks against the repo `VERSION` file
- `scripts/safe_zip.sh` — create `blux10k_safe_YYYYMMDD.zip` excluding common sensitive/cache/git artifacts (must be run from repository root, not from `$HOME`; does not exclude `~/.blux10k_backup`)
- `scripts/activate_venv.sh` — source-only bash venv activator for `.venv`/`venv`
- `scripts/py_venv.sh` — source-only POSIX helper to create/activate `.venv`
- `scripts/reload_shell.sh` — source-only helper to reload current shell rc file

## Helper functions (`dotfiles/.zshrc`)

`dotfiles/.zshrc` includes wrappers that execute installed scripts from:

```bash
$HOME/tools/scripts
```

This can be overridden with:

```bash
LOCAL_TOOL_SCRIPTS=/custom/path
```

Use:

```bash
b10k -h
b10k --help
```

to show the helper menu.

`dotfiles/.zshrc` exports the following each shell session:

```bash
BLUX10K_VERSION=2.0.0
BLUX10K_READY=1
```

`b10k version` (or `b10k --version` / `b10k -v`) prints the current blux10k version.

If a helper script is missing, wrappers show the missing script name, expected path, and a fix hint to copy `scripts/` into `$HOME/tools/scripts`.

Helper names:

- `pv`, `av`
- `backup_dotfiles`, `bootstrap_debian`, `diff_dotfiles`, `doctor`, `ensure_dirs`
- `link_dotfiles`, `list_dotfiles`, `reload_shell`, `restore_dotfiles_backup`
- `safe_zip`, `sync_dotfiles`, `unlink_dotfiles`, `update_plugins`
- `b10k` (help/entry layer)

## Dotfiles reference

- `.zshrc` — zsh defaults, helper wrappers, plugin initialization, p10k loading, blux10k readiness/version exports, and local override support
- `.p10k.zsh` — tracked Powerlevel10k prompt configuration (generated from upstream `p10k configure` flow)
- `.bashrc` — portable interactive bash defaults with guarded optional toolchain loading and local override support
- `.profile` — portable login-shell PATH and guarded environment loading with local override support
- `.gitconfig` — neutral shared baseline; personal identity/settings belong in `~/.gitconfig.local`

## Powerlevel10k model

- Theme source: upstream clone at `$HOME/powerlevel10k/powerlevel10k.zsh-theme`
- Config source: tracked `~/.p10k.zsh`
- Prompt wizard is manual: run `p10k configure` after installation from an interactive zsh session

This repository does not ship a custom Powerlevel10k theme framework.

## Usage notes

- **Copy vs symlink**: `cp_dotfiles.sh` copies files; `scripts/link.sh` creates symlinks.
- **Managed scope**: maintenance scripts operate on managed entries defined by `scripts/managed_entries.sh`.
- **Backup/restore**: backups are written under `~/.blux10k_backup/` and restored from the latest timestamp directory.
- **Debian assumption**: `scripts/bootstrap-debian.sh` is explicitly for Debian/Ubuntu systems.
  - Package installation runs as root directly, or via `sudo` for non-root users.
- **Source vs execute**:
  - source `scripts/activate_venv.sh`
  - source `scripts/py_venv.sh`
  - source `scripts/reload_shell.sh`
  - `reload_shell.sh` must be sourced; executing it cannot reload a parent shell.
- **Local overrides**: use untracked `.zshrc.local`, `.bashrc.local`, `.profile.local`, and `.gitconfig.local` for machine-specific settings.
  - `.zshrc.local` remains the extension seam and is sourced at the bottom of `.zshrc`.
- **AXIOM slot**: `$HOME/tools/scripts/axiom` is reserved for AXIOM script extensions.
- **AXIOM config**: `$HOME/.config/axiom` is reserved for AXIOM config state.
- **BluxGPT config**: `$HOME/.config/bluxgpt` is reserved for BluxGPT config state.

## Version

Current release target: **blux10k v2.0**.
