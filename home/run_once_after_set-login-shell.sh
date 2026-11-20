#!/usr/bin/env bash
set -euo pipefail

# Make zsh the login shell. Runs after the zsh and Oh My Zsh installers.
# Takes effect at the next login (in WSL: `wsl --shutdown`, then reopen).

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "Skipping login shell change: Linux only."
  exit 0
fi

zsh_path="$(command -v zsh || true)"
if [[ -z "$zsh_path" ]]; then
  echo "zsh not found; cannot set it as the login shell." >&2
  exit 1
fi

user="${USER:-$(id -un)}"
current_shell="$(getent passwd "$user" | cut -d: -f7)"
if [[ "$current_shell" == "$zsh_path" || "$(basename "$current_shell")" == "zsh" ]]; then
  echo "Login shell for $user is already $current_shell."
  exit 0
fi

priv=""
[[ $EUID -eq 0 ]] || { command -v sudo >/dev/null 2>&1 && priv="sudo"; }

# chsh only accepts shells listed in /etc/shells.
if ! grep -qxF "$zsh_path" /etc/shells; then
  echo "Adding $zsh_path to /etc/shells..."
  echo "$zsh_path" | $priv tee -a /etc/shells >/dev/null
fi

echo "Changing login shell for $user from $current_shell to $zsh_path..."
# Running chsh as root avoids the interactive password prompt.
if ! $priv chsh -s "$zsh_path" "$user"; then
  echo "chsh failed; set it manually with: chsh -s $zsh_path" >&2
  echo "Fallback: append 'exec zsh' for interactive shells to ~/.bashrc." >&2
  exit 1
fi
echo "Login shell changed; log out and back in for it to take effect."
