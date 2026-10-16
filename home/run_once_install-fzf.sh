#!/usr/bin/env bash
set -euo pipefail

fzf_home="$HOME/.fzf"

if [[ -d "$fzf_home" ]]; then
  echo "fzf already installed at $fzf_home."
  exit 0
fi

echo "Cloning fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_home"
"$fzf_home/install" --no-update-rc --completion --key-bindings
