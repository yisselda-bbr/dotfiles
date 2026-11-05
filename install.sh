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

# Python 3.13 via uv
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"
uv python install 3.13

# Load Homebrew, which may not be on PATH in non-login shells.
BREW=/home/linuxbrew/.linuxbrew/bin/brew
if [[ -x "$BREW" ]]; then
  eval "$("$BREW" shellenv)"
fi

# Install redis-cli via Homebrew without making Redis failures fatal.
if ! command -v redis-cli >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install redis || echo "WARN: brew install redis failed" >&2
  else
    echo "WARN: brew not found, skipping redis-cli" >&2
  fi
fi

echo "Dotfiles installation complete."
