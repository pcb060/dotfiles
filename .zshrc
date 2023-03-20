#!/usr/bin/env bash

source /usr/share/zsh/share/antigen.zsh
antigen init ~/.antigenrc

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
