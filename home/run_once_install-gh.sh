#!/usr/bin/env bash
set -euo pipefail

if command -v gh >/dev/null 2>&1; then
  echo "gh already installed at $(command -v gh)."
  exit 0
fi

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "Skipping gh install: Linux only." >&2
  exit 0
fi

sudo=""
[[ $EUID -eq 0 ]] || sudo="sudo"

if command -v apt-get >/dev/null 2>&1; then
  # Debian, Ubuntu and Kali ship gh in their own repositories.
  if apt-cache show gh >/dev/null 2>&1 || { $sudo apt-get update && apt-cache show gh >/dev/null 2>&1; }; then
    $sudo apt-get install -y gh
    exit 0
  fi
  # Not in the distro repositories (e.g. Kali): use GitHub's official apt repo.
  echo "gh not in distro repositories; adding the official GitHub CLI apt repository."
  keyring=/etc/apt/keyrings/githubcli-archive-keyring.gpg
  $sudo mkdir -p -m 755 /etc/apt/keyrings
  tmp_key="$(mktemp)"
  trap 'rm -f "$tmp_key"' EXIT
  curl --fail --silent --show-error --location \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg --output "$tmp_key"
  $sudo install -m 644 "$tmp_key" "$keyring"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] https://cli.github.com/packages stable main" \
    | $sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  $sudo apt-get update
  $sudo apt-get install -y gh
elif command -v dnf >/dev/null 2>&1; then
  $sudo dnf install -y gh
elif command -v pacman >/dev/null 2>&1; then
  $sudo pacman -S --noconfirm github-cli
elif command -v zypper >/dev/null 2>&1; then
  $sudo zypper --non-interactive install gh
else
  echo "No supported package manager found; install gh manually: https://cli.github.com" >&2
  exit 1
fi
