#!/bin/sh
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/aliases.zsh" "$HOME/.aliases.zsh"
ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"

# Linux dependencies (Debian/Ubuntu)
if command -v apt-get > /dev/null; then
  if ! command -v curl > /dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl
  fi
fi

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
