#!/usr/bin/env bash
cBLACK="$(tput setaf 0)"
cRED="$(tput setaf 1)"
cGREEN="$(tput setaf 2)"
cYELLOW="$(tput setaf 3)"
cBLUE="$(tput setaf 4)"
cMAGENTA="$(tput setaf 5)"
cCYAN="$(tput setaf 6)"
cWHITE="$(tput setaf 7)"
cRESET="$(tput sgr0)"

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