#!/usr/bin/env bash
# Ubuntu i3 setup script

echo "Installing i3 and dependencies..."

# Update package list
sudo apt update

# Install i3 window manager and related tools
sudo apt install -y \
    i3 \
    i3status \
    i3lock \
    dmenu \
    feh \
    xclip \
    stow \
    network-manager-gnome \
    pulseaudio-utils \
    xbacklight

echo "i3 and dependencies installed successfully!"

# Create dotfiles directory if it doesn't exist
DOTFILES="$HOME/.dotfiles"
if [ ! -d "$DOTFILES" ]; then
    echo "Creating dotfiles directory at $DOTFILES"
    mkdir -p "$DOTFILES"
fi

# Symlink current repo to ~/.dotfiles if not already there
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$CURRENT_DIR" != "$DOTFILES" ] && [ ! -L "$DOTFILES" ]; then
    echo "Creating symlink: $DOTFILES -> $CURRENT_DIR"
    ln -sf "$CURRENT_DIR" "$DOTFILES"
fi

# Make install script executable
chmod +x "$CURRENT_DIR/install"

# Run installation
export DOTFILES="$CURRENT_DIR"
export STOW_FOLDERS="i3"
"$CURRENT_DIR/install"

echo ""
echo "Setup complete!"
echo "To use i3:"
echo "  1. Log out of your current session"
echo "  2. Select 'i3' from the session menu on the login screen"
echo "  3. Log in"
echo ""
echo "Useful commands:"
echo "  - Edit config: vim ~/.config/i3/config"
echo "  - Reload i3 config: Mod+Shift+c"
echo "  - Restart i3: Mod+Shift+r"
echo ""
