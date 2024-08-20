### ZSH OPTIONS START

setopt rmstarsilent # disable zsh's confirmation for 'rm *'

# Get rid of .zcompdump* files in the home
# See: https://stackoverflow.com/questions/62931101/i-have-multiple-files-of-zcompdump-why-do-i-have-multiple-files-of-these
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

### ZSH OPTIONS END


### SHELL UTILS START
source ~/.zgenomrc 

eval "$(starship init zsh)"
export STARSHIP_LOG=error

source /usr/share/autojump/autojump.sh
### SHELL UTILS END


### SOURCING START

for file in ~/.myutils/*; do
  source "$file"
done

### SOURCING END

