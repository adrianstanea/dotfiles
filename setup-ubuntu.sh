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
    git \
    build-essential \
    autoconf \
    libcurl4-openssl-dev \
    libexpat1-dev \
    libpcre2-dev \
    libssl-dev \
    zlib1g-dev \
    gettext \
    perl \
    network-manager-gnome \
    pulseaudio-utils \
    xbacklight

install_latest_git() (
    set -euo pipefail

    local git_repo latest_git_tag build_dir
    git_repo="https://github.com/git/git.git"
    latest_git_tag="$(git ls-remote --tags --refs "$git_repo" 'refs/tags/v*' |
        awk -F '\t' '$2 ~ /^refs\/tags\/v[0-9]+\.[0-9]+\.[0-9]+$/ { sub(/^refs\/tags\//, "", $2); print $2 }' |
        sort -V |
        tail -n 1)"

    if [ -z "$latest_git_tag" ]; then
        echo "Could not find the latest stable Git release tag." >&2
        exit 1
    fi

    build_dir="$(mktemp -d)"
    trap 'rm -rf "$build_dir"' EXIT

    echo "Building Git $latest_git_tag from source..."
    git clone --depth 1 --branch "$latest_git_tag" "$git_repo" "$build_dir/git"
    cd "$build_dir/git"
    make configure
    ./configure --prefix=/usr/local
    make -j"$(nproc)" all
    sudo make install
)

install_latest_git || exit 1
hash -r
echo "Installed $(git --version) at $(command -v git)"

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
