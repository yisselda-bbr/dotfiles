#!/bin/sh
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
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
if ! command -v node > /dev/null; then
  nvm install --lts
fi

# Install just from GitHub releases (Linux x86_64)
if ! command -v just >/dev/null; then
  JUST_VERSION=1.38.0
  curl -fsSL -o /tmp/just.tar.gz \
    "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf /tmp/just.tar.gz -C /tmp
  sudo install -m 0755 /tmp/just /usr/local/bin/just
  rm -f /tmp/just /tmp/just.tar.gz
fi

# Install uv
if ! command -v uv >/dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if command -v apt-get > /dev/null; then  
  pkgs="curl git postgresql postgresql-client redis-tools build-essential libpq-dev python3.13 python3.13-venv python3.13-dev"
  sudo apt-get update
  sudo apt-get install -y $pkgs
fi
