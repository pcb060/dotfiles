#!/usr/bin/env zsh
# shellcheck shell=bash

# Color helpers
cBLACK="$(tput setaf 0)" && export cBLACK
cRED="$(tput setaf 1)" && export cRED
cGREEN="$(tput setaf 2)" && export cGREEN
cYELLOW="$(tput setaf 3)" && export cYELLOW
cBLUE="$(tput setaf 4)" && export cBLUE
cMAGENTA="$(tput setaf 5)" && export cMAGENTA
cCYAN="$(tput setaf 6)" && export cCYAN
cWHITE="$(tput setaf 7)" && export cWHITE
cRESET="$(tput sgr0)" && export cRESET
function pBlack() {
  printf "%s%s%s\n" "$cBLACK" "$1" "$cRESET"
}
function pRed() {
  printf "%s%s%s\n" "$cRED" "$1" "$cRESET"
}
function pGreen() {
  printf "%s%s%s\n" "$cGREEN" "$1" "$cRESET"
}
function pYellow() {
  printf "%s%s%s\n" "$cYELLOW" "$1" "$cRESET"
}
function pBlue() {
  printf "%s%s%s\n" "$cBLUE" "$1" "$cRESET"
}
function pMagenta() {
  printf "%s%s%s\n" "$cMAGENTA" "$1" "$cRESET"
}
function pCyan() {
  printf "%s%s%s\n" "$cCYAN" "$1" "$cRESET"
}
function pWhite() {
  printf "%s%s%s\n" "$cWHITE" "$1" "$cRESET"
}

# kill all jps services with matching name
function killbyname() {
  kill -9 "$(jps | grep "$1" | cut -d " " -f 1)" 2> /dev/null
  if [ "$?" -eq 0 ]; then
    pGreen "killbyname: Process \"$1\" killed succesfully"
  else
    pRed "killbyname: Failed to find or kill process \"$1\""
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
  input=$(cat $1)
  printf "%s" "$input" | xsel --clipboard --input
  local lines=$(wc -l $1 | awk '{print $1}')
  local chars=$(wc -m $1 | awk '{print $1}')
  echo "✅ Copied file contents to clipboard. Preview:"
  echo "${input:0:100}$( [ ${#input} -gt 100 ] && echo "…")" | bat --file-name="$1" --style=grid
  echo "Total: $lines lines, $chars characters."
}

# xsel implementation
xcf() {
  if [[ -f "$1" ]]; then
    xsel --clipboard --input < "$1"
    pGreen "✅ Copied file to clipboard: $1"
  else
    pRed "❌ File not found: $1"
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
      pGreen "Virtual environment created in '$venv_dir'."
    else
      pRed "Aborting. Virtual environment not created."
      return 1
    fi
  fi

  # shellcheck disable=SC1091
  { source "$venv_dir/bin/activate" && pGreen "Activated virtual environment in '$venv_dir'." ; } \
    || pRed "Failed to activate virtual environment."
}
