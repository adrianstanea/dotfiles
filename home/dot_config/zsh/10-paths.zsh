# General executable and documentation paths.

zsh_add_path \
  "$HOME/bin" \
  "$HOME/.local/bin" \
  /usr/local/bin \
  /opt/nvim-linux-x86_64/bin \
  /usr/local/texlive/2025/bin/x86_64-linux

export MANPATH="/usr/local/texlive/2025/texmf-dist/doc/man:${MANPATH#:}"
export INFOPATH="/usr/local/texlive/2025/texmf-dist/doc/info:${INFOPATH#:}"
