#!/usr/bin/env bash

source ~/.myaliases

source /usr/share/zsh/share/antigen.zsh
antigen init ~/.antigenrc

eval "$(starship init zsh)"
