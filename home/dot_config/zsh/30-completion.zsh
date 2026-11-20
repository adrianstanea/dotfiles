# Register custom completions before initializing completion.

if [[ -d $HOME/.zfunc ]]; then
  fpath=($HOME/.zfunc $fpath)
fi

autoload -Uz compinit
compinit

zsh_source_if_file "$HOME/.oh-my-zsh/completions/_bun"

if (( $+commands[uv] )); then
  eval "$(uv generate-shell-completion zsh)"
fi
if (( $+commands[uvx] )); then
  eval "$(uvx --generate-shell-completion zsh)"
fi
