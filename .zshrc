#!/usr/bin/env zsh

### ZSH OPTIONS START
setopt rmstarsilent # disable zsh's confirmation for 'rm *'

# Get rid of .zcompdump* files in the home
# See: https://stackoverflow.com/questions/62931101/i-have-multiple-files-of-zcompdump-why-do-i-have-multiple-files-of-these
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
### ZSH OPTIONS END

### HISTORY OPTIONS START
setopt inc_append_history
setopt share_history
### HISTORY OPTIONS END

### DEFAULTS START
export VISUAL=neovim
export EDITOR="$VISUAL"
### DEFAULTS END

### SHELL UTILS START
# zgenom
source ~/.zgenomrc 

# starship
eval "$(starship init zsh)"
export STARSHIP_LOG=error

# autojump
[ -f /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh

# fzf
if [[ ! "$PATH" == */opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/fzf/bin"
fi
source <(fzf --zsh)
### SHELL UTILS END


### SOURCING START
for file in ~/.myutils/*; do
  source "$file"
done

if [ -d ~/.localutils ]; then
  for file in ~/.localutils/*; do
    source "$file"
  done
fi
### SOURCING END

### PATH START
[ -f /home/$USER/.pathsrc ] && source /home/$USER/.pathsrc
### PATH END
