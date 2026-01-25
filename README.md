# dotfiles

My personal dotfiles configuration, inspired by ThePrimeagen's setup.

## i3 Window Manager Setup

### Quick Install (Ubuntu)

```bash
# Clone the repository
git clone https://github.com/adrianstanea/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the setup script
chmod +x setup-ubuntu.sh
./setup-ubuntu.sh
```

### Manual Installation

1. Install dependencies:
```bash
sudo apt update
sudo apt install -y i3 i3status i3lock dmenu feh xclip stow network-manager-gnome pulseaudio-utils xbacklight
```

2. Install dotfiles using GNU Stow:
```bash
cd ~/dotfiles
export DOTFILES="$HOME/dotfiles"
export STOW_FOLDERS="i3"
./install
```

3. Log out and select "i3" from your session manager

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

- **i3 config**: `~/.config/i3/config` (via `i3/.config/i3/config`)

## TODO
- Setup tmux: actually use sessions
- Save my nvim setup (telescope??? + harpoon??)
- Explore fuzzy find
- Add custom scripts (tmux-sessionizer, etc.)
- Add keyboard layout customization (xkb)
- Add bin scripts for utilities