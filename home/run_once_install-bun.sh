#!/usr/bin/env bash
set -euo pipefail

bun_home="$HOME/.bun"

if [[ -d "$bun_home" ]]; then
  echo "bun already installed at $bun_home."
  exit 0
fi

echo "Installing bun..."
curl -fsSL https://bun.sh/install | bash
