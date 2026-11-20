#!/usr/bin/env bash
set -euo pipefail

# Zsh is required by Oh My Zsh and the managed ~/.config/zsh configuration.
# The `before` prefix makes chezmoi run this ahead of the other run_once scripts.

if command -v zsh >/dev/null 2>&1; then
  echo "zsh already installed at $(command -v zsh)."
  exit 0
fi

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "Install zsh manually on this platform." >&2
  exit 1
fi

priv=""
[[ $EUID -eq 0 ]] || priv="sudo"

echo "Installing zsh..."
if command -v apt-get >/dev/null 2>&1; then
  $priv apt-get update
  $priv apt-get install -y zsh
elif command -v dnf >/dev/null 2>&1; then
  $priv dnf install -y zsh
elif command -v pacman >/dev/null 2>&1; then
  $priv pacman -S --needed --noconfirm zsh
elif command -v zypper >/dev/null 2>&1; then
  $priv zypper --non-interactive install zsh
elif command -v apk >/dev/null 2>&1; then
  $priv apk add zsh
else
  echo "No supported package manager found; install zsh manually." >&2
  exit 1
fi
