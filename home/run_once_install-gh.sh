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
  echo "gh is not in the apt repositories; see https://github.com/cli/cli/blob/trunk/docs/install_linux.md" >&2
  exit 1
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
