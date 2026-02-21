#!/usr/bin/env bash

# GENERAL #
  alias clc="clear"
  alias l="ll"
  alias la="ll -a"
  alias lla="la"
  alias lr="ll -R"
  alias lt="ll -T"
  alias lT="ll --total-size"

# UTILS #
  alias mi="micro"
  alias bat="batcat"
    alias b="bat"
    alias cbat="bat --paging=never"
  alias r="ranger"
  alias v="nvim"
    alias n="v"
    alias neovim="v"
  alias kbn="killbyname"
  alias ls="eza --git --icons=always --smart-group" # override
  alias df="duf" # override
  alias ps="procs" # override
  alias ping="gping" #override
  alias fd="fdfind"
  alias lg="lazygit"
  alias tm="tmux new-session -A -s main"
  	alias tmrw="tmux rename-window"
  alias tally="sort | uniq -c | sort"
  alias gogh='bash -c "$(wget -qO- https://git.io/vQgMr)"'
  alias dvenv="deactivate"
  
# NAVIGATION #
  alias ..="cd .."
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias cdsha="cd $SHARED"

# META #
  alias mys="echo -n 'Sourcing .zshrc... ' && source ~/.zshrc && echo 'OK!'"

