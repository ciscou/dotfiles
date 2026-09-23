#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $BASH_SOURCE)
WORKDIR=$(pwd)

symlink() {
  echo "symlinking $1 <- $2"
  [ -f "$2" ] && cp "$2{,.bak}"
  ln -sf "$WORKDIR/$1" "$HOME/$2"
}

git_clone() {
  echo "git cloning $1 into $2"
  git clone "$1" "$HOME/$2"
}

if [ -d "$HOME/.config/alacritty" ]; then
  symlink "alacritty/alacritty.toml" ".config/alacritty/alacritty.toml"

  if [ ! -d "$HOME/.config/alacritty/themes" ]; then
    git_clone "https://github.com/alacritty/alacritty-theme" ".config/alacritty/themes"
  fi
else
  echo "Go to https://alacritty.org/#Installation to install alacritty"
fi

if [ -d "$HOME/.config/zellij" ]; then
  symlink "zellij/config.kdl" ".config/zellij/config.kdl"
else
  echo "Go to https://zellij.dev/documentation/installation.html#binary-download to install zellij"
fi

if [ -d "$HOME/.config/nvim" ]; then
  # required
  mv ~/.config/nvim{,.bak}

  # optional but recommended
  # mv ~/.local/share/nvim{,.bak}
  # mv ~/.local/state/nvim{,.bak}
  # mv ~/.cache/nvim{,.bak}

  symlink "nvim" ".config/nvim"
else
  echo "Go to https://neovim.io/doc/install/ to install neovim"
fi
