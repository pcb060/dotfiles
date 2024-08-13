#!/usr/bin/env bash

alias gl="git log"
  alias glf='gl --first-parent'
  alias glp='gl --color --pretty=format:"%C(yellow)[ %h ] %Cgreen(%ad) %C(cyan)%an%Creset > %s%C(brightblack)%d" --date=format:"%Y-%m-%d %H:%M:%S"'
  alias glpg='glp --graph'
  alias glpf='glp --first-parent'
  alias gll='git_log_diff'

alias gs="git status"

alias ga="git add"
alias gk="git commit"
  alias gkm="git commit -m"
  alias gkam="git commit -am"
  alias gkaa="git commit --amend"

alias gb="git branch"
  alias gba="gb -a"
  alias gbD="gb -D"
  alias gbb="git_branch_blame"
  alias gbm="gb --merged"
  alias gbn="gb --no-merged"

alias gc="git checkout"
  alias gcd="gc develop"
  alias gcb="gc -b"
  alias gcs="gc smart-checkout"

alias gf="git fetch"
  alias gfa="gf --all"
alias gp="git pull"
  alias gpa="gp --all"
alias gm="git merge"
  alias gmf="gm --ff"
  alias gmn="gm --no-ff"
  alias gmfo="gm --ff-only"
alias gP="git push"
  alias gPf="gP --force"
  alias gPD="gP origin --delete"

alias gd="git diff"
  alias gdn="gd --name-only"
alias gds="git show"
  alias gdsn="gds --name-only"

alias gsta="git stash"
  alias gstal="gsta list"
  alias gstas="gsta show"
  alias gstaa="gsta apply"
  alias gstap="gsta pop"

alias gch="git cherry-pick"
  alias gchn="gch -n"

alias gri="git rebase -i"
alias grif="git_fast_interactive_rebase"

alias gr="git restore"
	alias grs="gr --staged"
alias grc="git checkout --" # git restore for older git versions

alias gR="git reset"
alias gRs="gR --soft"
alias gRh="gR --hard"

