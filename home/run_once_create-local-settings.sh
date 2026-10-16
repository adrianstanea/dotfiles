#!/usr/bin/env bash
set -euo pipefail

secrets_file="$HOME/.zshrc.secrets"
local_zsh_file="$HOME/.config/zsh/local.zsh"
local_git_file="$HOME/.gitconfig.local"

if [[ -e "$secrets_file" ]]; then
  echo "$secrets_file already exists; leaving it untouched."
else
  echo "Creating template $secrets_file (chmod 600, fill in real values; never commit this file)."
  install -m 600 /dev/null "$secrets_file"
  cat > "$secrets_file" <<'EOF'
# Machine-local secrets, sourced by ~/.config/zsh/90-local.zsh.
# Never commit this file. Fill in the values this machine actually needs, e.g.:
#
# export GITHUB_PERSONAL_ACCESS_TOKEN="..."
# export CLOUDSMITH_API_KEY="..."
# export LM_LICENSE_FILE="..."
EOF
fi

if [[ -e "$local_zsh_file" ]]; then
  echo "$local_zsh_file already exists; leaving it untouched."
else
  echo "Creating template $local_zsh_file (fill in machine-local overrides; never commit this file)."
  mkdir -p "$(dirname "$local_zsh_file")"
  cat > "$local_zsh_file" <<'EOF'
# Machine-local zsh overrides, sourced by ~/.config/zsh/90-local.zsh.
# Never commit this file. Use it for settings specific to this machine only.
EOF
fi

if [[ -e "$local_git_file" ]]; then
  echo "$local_git_file already exists; leaving it untouched."
else
  echo "Creating template $local_git_file (fill in machine-local Git settings; never commit this file)."
  cat > "$local_git_file" <<'EOF'
# Machine-local Git settings, included last by ~/.gitconfig.
# Never commit this file. Use it for settings specific to this machine, e.g.:
#
# [safe]
# 	directory = /path/to/repository
EOF
fi
