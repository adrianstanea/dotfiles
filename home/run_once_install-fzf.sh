#!/usr/bin/env bash
set -euo pipefail

fzf_home="$HOME/.fzf"

if [[ -x "$fzf_home/bin/fzf" ]]; then
  echo "fzf already installed at $fzf_home."
  exit 0
fi

if [[ ! -d "$fzf_home/.git" ]]; then
  echo "Cloning fzf..."
  rm -rf "$fzf_home"
  git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_home"
fi
"$fzf_home/install" --no-update-rc --completion --key-bindings
