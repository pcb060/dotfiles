# Path to your oh-my-zsh installation.
export ZSH="/home/jacopo/.oh-my-zsh"

# rust cargo
export PATH="$HOME/.cargo/bin:$PATH"

# aliases
source $HOME/.aliases
  
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# antigen
source /usr/share/zsh/share/antigen.zsh
antigen init ~/.antigenrc

# autojump
source /etc/profile.d/autojump.sh

# micro
export EDITOR=micro

# starship
eval "$(starship init zsh)"