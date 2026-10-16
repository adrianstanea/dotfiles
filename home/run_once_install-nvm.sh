#!/usr/bin/env bash
set -euo pipefail

nvm_version="v0.40.3"
nvm_dir="$HOME/.nvm"

if [[ -d "$nvm_dir" ]]; then
  echo "nvm already installed at $nvm_dir."
  exit 0
fi

echo "Installing nvm $nvm_version..."
PROFILE=/dev/null \
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | bash

export NVM_DIR="$nvm_dir"
# shellcheck source=/dev/null
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*
