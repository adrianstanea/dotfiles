#!/usr/bin/env bash
set -euo pipefail

# uv (Python package/tool manager): https://docs.astral.sh/uv/
# Installs into ~/.local/bin. Upgrade later with `uv self update`.

if command -v uv >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/uv" ]]; then
  echo "uv already installed; upgrade with: uv self update"
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install uv." >&2
  exit 1
fi

echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
