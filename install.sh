#!/bin/sh
git clone --bare https://github.com/fduch2k/dotfiles $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f
