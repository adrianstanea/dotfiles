#!/usr/bin/env bash
set -euo pipefail

zsh_home="$HOME/.oh-my-zsh"
custom_plugins="$zsh_home/custom/plugins"

if [[ ! -d "$zsh_home" ]]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed at $zsh_home."
fi

declare -A plugins=(
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [fzf-tab]="https://github.com/Aloxaf/fzf-tab"
  [fzf-zsh-plugin]="https://github.com/unixorn/fzf-zsh-plugin.git"
)

mkdir -p "$custom_plugins"
for plugin in "${!plugins[@]}"; do
  if [[ -d "$custom_plugins/$plugin" ]]; then
    echo "Plugin $plugin already present."
  else
    echo "Cloning plugin $plugin..."
    git clone --depth 1 "${plugins[$plugin]}" "$custom_plugins/$plugin"
  fi
done
