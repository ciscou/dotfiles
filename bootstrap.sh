#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $BASH_SOURCE)
WORKDIR=$(pwd)

symlink() {
  echo "symlinking $1 <- $2"
  [ -f "$2" ] && cp "$2{,.bak}"
  ln -sf "$WORKDIR/$1" "$HOME/$2"
}

if [ -d "$HOME/.config/alacritty" ]; then
  symlink "alacritty/alacritty.toml" ".config/alacritty/alacritty.toml"
else
  echo "Go to https://alacritty.org/#Installation to install alacritty"
fi

if [ -d "$HOME/.config/zellij" ]; then
  symlink "zellij/config.kdl" ".config/zellij/config.kdl"
else
  echo "Go to https://zellij.dev/documentation/installation.html#binary-download to install zellij"
fi
