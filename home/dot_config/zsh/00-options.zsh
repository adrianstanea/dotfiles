# Shared helpers and shell options.

typeset -g ZSH_CONFIG_DIR=${ZSH_CONFIG_DIR:-$HOME/.config/zsh}

zsh_source_if_file() {
  [[ -r $1 ]] && source "$1"
}

zsh_add_path() {
  local directory
  for directory in "$@"; do
    [[ -d $directory ]] && path=($directory $path)
  done
}

typeset -U path fpath
