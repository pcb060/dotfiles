#!/usr/bin/env zsh

yazi-open() {
  yazi < /dev/tty
  zle reset-prompt
}
zle -N yazi-open
bindkey '^e' yazi-open
