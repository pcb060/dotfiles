#!/usr/bin/env zsh
# shellcheck shell=bash

cBLACK="$(tput setaf 0)" && export cBLACK
cRED="$(tput setaf 1)" && export cRED
cGREEN="$(tput setaf 2)" && export cGREEN
cYELLOW="$(tput setaf 3)" && export cYELLOW
cBLUE="$(tput setaf 4)" && export cBLUE
cMAGENTA="$(tput setaf 5)" && export cMAGENTA
cCYAN="$(tput setaf 6)" && export cCYAN
cWHITE="$(tput setaf 7)" && export cWHITE
cRESET="$(tput sgr0)" && export cRESET

# kill all jps services with matching name
function killbyname() {
  kill -9 "$(jps | grep "$1" | cut -d " " -f 1)" 2> /dev/null
  if [ "$?" -eq 0 ]; then
    echo "killbyname: Process \"$1\" killed succesfully"
  else
    echo "killbyname: Failed to find or kill process \"$1\""
  fi
}

function hg() {
  history | grep --color=always "$1" | grep -v ' hg ' | cbat --style=grid,numbers,snip
}

function rbat() {
	tac "$1" | bat
}

# xsel implementation
xc() {
  local input
  input=$(cat)
  printf "%s" "$input" | xsel --clipboard --input
  echo "📋 Copied to clipboard: ${input:0:60}$( [ ${#input} -gt 60 ] && echo "…")"
}

# xsel implementation
xcf() {
  if [[ -f "$1" ]]; then
    xsel --clipboard --input < "$1"
    echo "📋 Copied file to clipboard: $1"
  else
    echo "❌ File not found: $1"
  fi
}

# Create and/or activate a Python virtual environment in the current directory
# Assumes venv directory is called .venv. Asks for confirmation.
venv() {
  local venv_dir=".venv"
  if [ ! -d "$venv_dir" ]; then
    read -r "?Virtual environment not found. Create one in '$venv_dir'? (y/n): " choice
    # Assumes empty choice is a no
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      python3 -m venv "$venv_dir"
      echo "Virtual environment created in '$venv_dir'."
    else
      echo "Aborting. Virtual environment not created."
      return 1
    fi
  fi

  # shellcheck disable=SC1091
  { source "$venv_dir/bin/activate" && echo "Activated virtual environment in '$venv_dir'." ; } \
    || echo "Failed to activate virtual environment."
}
