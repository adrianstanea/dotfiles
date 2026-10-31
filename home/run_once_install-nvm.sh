#!/usr/bin/env bash
set -euo pipefail

nvm_version="v0.40.3"
if [[ -n "${NVM_DIR:-}" ]]; then
  nvm_dir="$NVM_DIR"
elif [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
  nvm_dir="$XDG_CONFIG_HOME/nvm"
else
  nvm_dir="$HOME/.nvm"
fi
export NVM_DIR="$nvm_dir"

if [[ ! -s "$nvm_dir/nvm.sh" ]]; then
  echo "Installing nvm $nvm_version at $nvm_dir..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | PROFILE=/dev/null bash
else
  echo "nvm already installed at $nvm_dir."
fi

# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*
