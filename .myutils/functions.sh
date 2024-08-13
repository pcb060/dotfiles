#!/usr/bin/env bash

# kill all jps services with matching name
function killbyname() {
  kill -9 `jps | grep "$1" | cut -d " " -f 1` 2> /dev/null
  if [ "$?" -eq 0 ]; then
    echo "killbyname: Process \"$1\" killed succesfully"
  else
    echo "killbyname: Failed to find or kill process \"$1\""
  fi
}

function hg() {
  history | grep --color=always $1 | grep -v ' hg ' | cbat --style=grid,numbers,snip
}

function rbat() {
	tac $1 | bat
}