#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/aliases.zsh" "$HOME/.aliases.zsh"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# Node & nvm setup
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi
if ! command -v node >/dev/null 2>&1; then
  nvm install --lts
fi

# Install just from GitHub releases (Linux x86_64)
if ! command -v just >/dev/null 2>&1; then
  JUST_VERSION=1.38.0
  curl -fsSL -o /tmp/just.tar.gz \
    "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf /tmp/just.tar.gz -C /tmp
  sudo install -m 0755 /tmp/just /usr/local/bin/just
  rm -f /tmp/just /tmp/just.tar.gz
fi

# Install uv and Python 3.13
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"
uv python install 3.13

# Only use apt when one of the required packages is missing. Let apt wait for
# the dpkg lock, which may be held by unattended-upgrades during VM startup.
if command -v apt-get >/dev/null 2>&1; then
  pkgs=(postgresql-client redis-tools libpq-dev)
  missing=()
  for pkg in "${pkgs[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done

  if ((${#missing[@]})); then
    echo "Installing missing apt packages: ${missing[*]}"
    apt_opts=(-o DPkg::Lock::Timeout=900)
    update_succeeded=false
    for i in {1..30}; do
      if sudo apt-get "${apt_opts[@]}" update; then
        update_succeeded=true
        break
      fi
      echo "apt update busy, retrying ($i/30)..."
      sleep 10
    done
    if [[ "$update_succeeded" != true ]]; then
      echo "apt-get update failed after 30 attempts" >&2
      exit 1
    fi
    sudo apt-get "${apt_opts[@]}" install -y "${missing[@]}"
  else
    echo "apt packages already present, skipping"
  fi
fi
