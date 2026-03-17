#!/usr/bin/env bash

# GENERAL #
alias clc="clear"
alias l="ll"
alias la="ll -a"
alias lla="la"
alias lr="ll -R"
  alias lr2="ll -RL2"
  alias lr3="ll -RL3"
  alias lr4="ll -RL4"
alias lt="ll -T"
alias lT="ll --total-size"

# UTILS #
alias mi="micro"
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

# META #
alias mys="echo -n 'Sourcing .zshrc... ' && source ~/.zshrc && echo 'OK!'"

# DOCKER, PODMAN & DOCKER-COMPOSE #
alias dcd="docker-compose down"
  alias dcdo="docker-compose down --remove-orphans"
alias dcu="docker-compose up"
  alias dcud="docker-compose up -d"

# K8S #
alias k3stop="sudo systemctl stop k3s"
alias k3start="sudo systemctl start k3s"

