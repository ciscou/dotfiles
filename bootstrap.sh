#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $BASH_SOURCE)
WORKDIR=$(pwd)

if [ -d ~/.config/alacritty ]; then
  [ -f ~/.config/alacritty/alacritty.toml ] && cp ~/.config/alacritty/alacritty.toml{,.bak}
  ln -sf $WORKDIR/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
fi

if [ -d ~/.config/zellij ]; then
  [ -f ~/.config/zellij/config.kdl ] && cp ~/.config/zellij/config.kdl{,.bak}
  ln -sf $WORKDIR/zellij/config.kdl ~/.config/zellij/config.kdl
fi
