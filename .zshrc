### ZSH OPTIONS START
setopt rmstarsilent # disable zsh's confirmation for 'rm *'
### ZSH OPTIONS END

### SOURCING START

for file in ~/.myutils/*; do
  source "$file"
done

### SOURCING END


### SHELL UTILS START
source ~/.zgenomrc 

eval "$(starship init zsh)"
export STARSHIP_LOG=error

source /usr/share/autojump/autojump.sh
### SHELL UTILS END
