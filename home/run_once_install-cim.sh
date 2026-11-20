#!/usr/bin/env bash
set -euo pipefail

# Code in Motion (cim): https://github.com/analogdevicesinc/cim
# Installs the latest release into ~/.local/bin. Upgrade later with `cim utils update`.

if command -v cim >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/cim" ]]; then
  echo "cim already installed; upgrade with: cim utils update"
  exit 0
fi

case "$(uname -s)" in
  Linux | Darwin) ;;
  *)
    echo "Skipping cim install: only Linux and macOS are supported by the install script." >&2
    exit 0
    ;;
esac

missing=()
for tool in git make tar unzip python3 curl; do
  command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
done
if ! python3 -c 'import venv, pip' >/dev/null 2>&1; then
  missing+=("python3-venv/pip")
fi
if ((${#missing[@]} > 0)); then
  echo "cim needs: ${missing[*]}" >&2
  echo "Debian/Ubuntu/Kali: sudo apt install -y git make tar unzip python3 python3-pip python3-venv curl" >&2
  exit 1
fi

echo "Installing cim..."
curl -fsSL https://analogdevicesinc.github.io/cim/install.sh | sh
