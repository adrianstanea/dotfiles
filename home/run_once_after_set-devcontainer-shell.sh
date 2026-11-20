#!/usr/bin/env bash
set -euo pipefail

# In dev containers VS Code decides the terminal shell when its server starts,
# so `chsh` alone is not picked up until the window reloads. Make new terminals
# use zsh immediately:
#   1. an interactive-bash hook in ~/.bashrc that execs zsh (containers only);
#   2. a VS Code remote machine setting selecting the zsh terminal profile.

in_container=false
if [[ -n "${REMOTE_CONTAINERS:-}${CODESPACES:-}" || -f /.dockerenv ]]; then
  in_container=true
fi
if [[ "$in_container" != true ]]; then
  echo "Not in a container; skipping dev container shell setup."
  exit 0
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh not found; skipping dev container shell setup." >&2
  exit 0
fi

bashrc="$HOME/.bashrc"
marker="# >>> dotfiles: switch to zsh in containers >>>"
if [[ -f "$bashrc" ]] && grep -qF "$marker" "$bashrc"; then
  echo "$bashrc already switches to zsh."
else
  echo "Adding zsh hook to $bashrc..."
  cat >>"$bashrc" <<'EOF'

# >>> dotfiles: switch to zsh in containers >>>
# Only for interactive shells; set DOTFILES_NO_ZSH_EXEC=1 to stay in bash.
if [[ $- == *i* && -z "${ZSH_VERSION:-}" && -z "${DOTFILES_NO_ZSH_EXEC:-}" && -z "${BASH_EXECUTION_STRING:-}" ]] \
  && command -v zsh >/dev/null 2>&1; then
  export SHELL="$(command -v zsh)"
  exec zsh
fi
# <<< dotfiles: switch to zsh in containers <<<
EOF
fi

settings="$HOME/.vscode-server/data/Machine/settings.json"
if [[ -e "$settings" ]]; then
  echo "$settings exists; leaving it untouched (set terminal.integrated.defaultProfile.linux to zsh there if wanted)."
else
  echo "Writing $settings..."
  mkdir -p "$(dirname "$settings")"
  cat >"$settings" <<'EOF'
{
  "terminal.integrated.defaultProfile.linux": "zsh"
}
EOF
fi
echo "New terminals will start in zsh; no reload or 'exec zsh' needed."
