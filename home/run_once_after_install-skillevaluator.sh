#!/usr/bin/env bash
set -euo pipefail

# NVIDIA SkillEvaluator: https://github.com/NVIDIA/SkillEvaluator
# Installed as a uv tool (Python 3.12-3.14). Runs after run_once_install-uv.sh.
# Upgrade later with `uv tool upgrade skillevaluator`.

export PATH="$HOME/.local/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required to install skillevaluator but was not found." >&2
  exit 1
fi

installed_tools="$(uv tool list 2>/dev/null || true)"
if grep -q '^skillevaluator ' <<<"$installed_tools"; then
  echo "skillevaluator already installed; upgrade with: uv tool upgrade skillevaluator"
  exit 0
fi

echo "Installing skillevaluator..."
uv tool install --python 3.13 skillevaluator
