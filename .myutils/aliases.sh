#!/usr/bin/env bash

# GENERAL #
  alias clc="clear"
  alias l="ll"
  alias la="ll -a"
  alias lla="la"

# UTILS #
  alias cbat="bat --paging=never"
  alias mi="micro"
  alias bat="batcat"
    alias b="bat"
  alias r="ranger"
  alias v="nvim"
    alias n="v"
    alias neovim="v"
  alias kbn="killbyname"
  alias ls="eza" # override
  alias df="duf" # override
  alias ps="procs" # override
  alias ping="gping" #override
  alias fd="fdfind"
  alias lg="lazygit"
  alias gogh='bash -c "$(wget -qO- https://git.io/vQgMr)"'
  
# NAVIGATION #
  alias ..="cd .."
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias cdsha="cd $SHARED"

# META #
  alias mys="echo -n 'Sourcing .zshrc... ' && source ~/.zshrc && echo 'OK!'"

