#!/usr/bin/env bash

# GENERAL #
alias clc="clear"
alias ls="eza --git --icons=always --smart-group" # override
alias ll="ls -l"
  alias l="ll"
  alias la="ll -a"
  alias lla="la"
alias lr="ll -R"
  alias lr2="lr -L2"
  alias lr3="lr -L3"
  alias lr4="lr -L4"
alias lt="ll -T"
  alias lt2="lt -L2"
  alias lt3="lt -L3"
  alias lt4="lt -L4"
alias lT="ll --total-size"

# UTILS #
alias mi="micro"
alias b="bat"
  alias cbat="bat --paging=never"
alias f="yazi"
alias v="nvim"
  alias n="v"
  alias neovim="v"
alias kbn="killbyname"
alias df="duf" # override
alias ps="procs" # override
alias fd="fdfind"
alias ddff="delta --diff-so-fancy"
alias lg="lazygit"
alias tm="tmux new-session -A -s main"
  alias tmrw="tmux rename-window"
alias tally="sort | uniq -c | sort"
alias gogh='bash -c "$(wget -qO- https://git.io/vQgMr)"'
alias dvenv="deactivate"
alias syu="sysupgrade"
alias syuy="sysupgrade -y"
alias tw="task"
  alias twa="task add"
  alias twdo="task done"
  alias twde="task delete"
  alias twm="task modify"
  alias twui="taskwarrior-tui"

# NAVIGATION #
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# META #
alias mys="echo -n 'Sourcing .zshrc... ' && source ~/.zshrc && echo 'OK!'"

# DOCKER, PODMAN & DOCKER-COMPOSE #
alias dc="docker-compose"
alias dcd="dc down"
  alias dcdo="dcd --remove-orphans"
alias dcu="dc up"
  alias dcud="dcu -d"

# K8S #
alias k3stop="sudo systemctl stop k3s"
alias k3start="sudo systemctl start k3s"

