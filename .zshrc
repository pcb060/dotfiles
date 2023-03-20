#!/usr/bin/env bash

source .myaliases

source /usr/share/zsh/share/antigen.zsh
antigen apply ~/.antigenrc

eval "$(starship init zsh)"
