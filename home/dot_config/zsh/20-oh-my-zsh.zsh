# Oh My Zsh and its plugins.

export ZSH=${ZSH:-$HOME/.oh-my-zsh}
ZSH_THEME=${ZSH_THEME:-robbyrussell}

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  fzf
  fzf-tab
  fzf-zsh-plugin
)

if [[ -r $ZSH/oh-my-zsh.sh ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print "zsh: Oh My Zsh was not found at $ZSH" >&2
fi
