# dotfiles

My personal dotfiles configuration, inspired by ThePrimeagen's setup.

## Setup with chezmoi

Git must already be available to clone this repository. The repository's root `install` script installs chezmoi into `~/.local/bin` if needed, then initializes and applies this existing clone without prompting. i3 and Git source installation are both disabled by default.

### VS Code Dev Containers

In VS Code's Remote > Containers > Dotfiles settings, use:

- Repository: `https://github.com/adrianstanea/dotfiles.git`
- Target Path: `~/dotfiles`
- Install Command: `install`

The Dev Containers extension clones the repository and invokes `install`; the script reuses that checkout rather than cloning again. Feature choices already stored in chezmoi's local config are preserved. On first setup, the defaults keep optional features and their dependencies disabled.

For a manual setup, install chezmoi using its [official installation instructions](https://www.chezmoi.io/install/), then initialize this local checkout:

Review the proposed changes, then apply them:

```bash
chezmoi --source "$HOME/dotfiles" init
chezmoi diff
chezmoi apply
```

During interactive initialization, choose whether to enable the i3 desktop, build the latest stable Git release from source, and/or install Analog Devices CodeFusion Studio. Package dependencies are installed only for enabled features, and Stow is no longer required.

To change feature selection later, edit `~/.config/chezmoi/chezmoi.toml` or run `chezmoi edit-config`, then run `chezmoi diff` followed by `chezmoi apply`. Disabling i3 removes its managed config files. Disabling Git source installation stops future builds. Neither action automatically removes installed system packages or `/usr/local/bin/git`; remove those manually if desired.

The package installer currently supports Ubuntu with APT. The Git source feature checks the latest stable upstream tag on each apply and builds only if `/usr/local/bin/git` is missing or out of date.

### Guides and workflow

- [Quick Start](https://www.chezmoi.io/quick-start/) for initialization, preview, and apply.
- [Manage machine-to-machine differences](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/) for templates and conditional targets.
- [Use scripts to perform actions](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/) for script ordering, idempotence, and change-triggered actions.
- [Install packages declaratively](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/) for feature-scoped package data and installation scripts.
- [Migrate from another dotfile manager](https://www.chezmoi.io/migrating-from-another-dotfile-manager/) for symlink-based managers.

Review `chezmoi diff` before applying changes. Use `chezmoi apply --dry-run --verbose` to preview actions; package scripts run only for enabled features, and disabling a feature does not remove its system packages.

### Managed Zsh configuration

Chezmoi manages `~/.zshrc` and all of `~/.config/zsh/*.zsh` (`00-options.zsh` through `50-environments.zsh`), sourced in numeric order by the `~/.zshrc` entry point. One exception: `90-local.zsh` is intentionally **not** tracked here — it only loads machine-local secrets (`~/.zshrc.secrets`) and an untracked `local.zsh` override, so it must be created directly on each machine, never committed.

Supporting tools referenced by this configuration are installed by dedicated, idempotent scripts (each skips itself if already installed):

- `run_once_install-ohmyzsh.sh` — Oh My Zsh (unattended, `KEEP_ZSHRC=yes`) plus the `zsh-syntax-highlighting`, `zsh-autosuggestions`, `fzf-tab`, and `fzf-zsh-plugin` custom plugins.
- `run_once_install-fzf.sh` — clones `junegunn/fzf` into `~/.fzf` and runs its own installer.
- `run_once_install-nvm.sh` — installs nvm (pinned version in the script), then the current Node LTS as the default.
- `run_once_install-bun.sh` — installs bun via its official install script.
- `run_once_install-nvim.sh.tmpl` — downloads the latest stable Neovim Linux x86_64 release into `/opt/nvim-linux-x86_64` (requires `sudo`; Linux only).
- `run_once_install-texlive.sh.tmpl` — gated behind the `texlive` feature (default off): downloads TeX Live (year and scheme pinned in `.chezmoidata/packages.yaml`, currently 2025/scheme-full) via the network installer. This is several GB and can take a long time; it's opt-in on purpose.

### Local settings scaffold

`run_once_create-local-settings.sh` creates empty, comment-only templates at `~/.zshrc.secrets` (mode 600) and `~/.config/zsh/local.zsh` *only if they don't already exist* — it never overwrites or reads existing content, and the templates contain no real values. Fill in the actual secrets/overrides for each machine by hand after this runs; neither file is ever tracked by chezmoi.

### CodeFusion Studio

When the `cfs` feature is enabled, `run_once_install-cfs.sh.tmpl` installs Analog Devices CodeFusion Studio (version pinned in `.chezmoidata/packages.yaml`) under `~/analog/cfs/<version>`. The installer requires a myAnalog account and EULA acceptance, so it cannot be downloaded automatically: the script expects `~/Downloads/CodeFusionStudio_<version>.run` to already be present (download it from the page linked in the script's own error message) and then runs the exact silent-install invocation recorded in that installer's own `InstallationLog.txt` (`install --am --al -c`).

The script does not install the bundled VS Code extension (`VSCode/cfs-ide-<version>.vsix`) automatically — install it from a VS Code terminal with `code --install-extension`, as the script's final output reminds you.

`~/.config/zsh/50-environments.zsh` defines a `cfs-env` alias (`setup_CFS`) that lazily adds `cfsutil` and the bundled toolchains (cmake, git, openocd, python, dtc, gcc, ...) to `PATH` for the current shell, following the same pattern as the existing `zephyr-env` and `maxim-env` aliases. It does not run automatically; it is a lazy toggle to avoid permanently cluttering `PATH`.

### Managed i3 configuration

When enabled, chezmoi manages `~/.config/i3/config` and `~/.config/i3status/config`. The i3 config includes custom monitor and resolution bindings under `~/dotfiles/bin`; those scripts are not currently present in this repository.

### Key Bindings

**Modifier Key**: `Alt` (Mod1)

#### Window Management
- `Mod+Return` - Open terminal
- `Mod+Shift+q` - Kill focused window
- `Mod+d` - Application launcher (dmenu)
- `Mod+h/j/k/l` - Focus left/down/up/right (vim keys)
- `Mod+Shift+h/j/k/l` - Move window left/down/up/right

#### Layouts
- `Mod+z` - Split horizontally
- `Mod+v` - Split vertically
- `Mod+f` - Fullscreen toggle
- `Mod+s` - Stacking layout
- `Mod+w` - Tabbed layout
- `Mod+e` - Toggle split layout

#### Workspaces
- `Mod+1-9,0` - Switch to workspace 1-10
- `Mod+Shift+1-9,0` - Move window to workspace 1-10

#### System
- `Mod+Shift+c` - Reload i3 config
- `Mod+Shift+r` - Restart i3
- `Mod+Shift+e` - Exit i3
- `Mod+r` - Resize mode (use h/j/k/l or arrows, then Esc)

#### Media Keys
- `XF86AudioRaiseVolume` - Increase volume
- `XF86AudioLowerVolume` - Decrease volume
- `XF86AudioMute` - Mute/unmute
- `XF86MonBrightnessUp/Down` - Adjust screen brightness

## Configuration Files

- **i3 config source**: `home/dot_config/i3/config.tmpl`
- **i3status config source**: `home/dot_config/i3status/config.tmpl`

## TODO
- Setup tmux: actually use sessions
- Save my nvim setup (telescope??? + harpoon??)
- Explore fuzzy find
- Add custom scripts (tmux-sessionizer, etc.)
- Add keyboard layout customization (xkb)
- Add bin scripts for utilities