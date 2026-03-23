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

# Print size of file in human-readable format
hrs() {
  usage() {
    echo "Usage: hrs [options] <file>"
    echo "Options:"
    echo "  -h, --help  Display this help message"
    return 1
  }

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
  fi

  stat --format=%s $1 | numfmt --to=si --suffix=B
}

# Download template gitignore file for specified language
ignore() {
  usage() {
    echo "Usage: ignore [-i] language"
    return 1
  }

  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    usage
  fi

  repo_url="https://github.com/github/gitignore"
  branch="main"
  raw_url="$repo_url/raw/$branch"

  check_cert_param=""
  lang=""
  if [ "$#" -eq 2 ]; then
    if [ "$1" = "-i" ]; then
      check_cert_param="--no-check-certificate"
      lang="$2"
    else
      echo "Invalid option: $1" 
      usage
    fi
  else
    lang="$1"
  fi

  lang=${lang^}

  wget "$check_cert_param" -O ".gitignore" "$raw_url/$lang.gitignore" \
    || echo "Download of template .gitignore file for language $lang failed"
}

# Execute command on all directories at current position
fad() {
  local comm; comm="$@"
  
  for dir in */; do
    [ -d "$dir" ] || continue
    printf "%bExecuting %b\"%s\"%b in directory %b%s%b\n" "$cYELLOW" "$cCYAN" "$comm" "$cYELLOW" "$cBLUE" "${dir//\//}" "$cRESET"
    (cd "$dir" && "$@" && echo)
  done
}

# Create template script file fitting bash best practices
script() {
  usage() {
    echo "Usage: script [-x] <filename>"
    echo "Options:"
    echo "  -x  Make file executable"
    return 1
  }

  # Check if the user provided a filename and optional -x flag
  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
      usage
  fi

  # Initialize variables
  make_executable=false
  filename=""

  # Handle arguments
  if [ "$#" -eq 2 ]; then
      if [ "$1" = "-x" ]; then
          make_executable=true
          filename="$2"
      else
          echo "Invalid option: $1"
          usage
      fi
  else
      filename="$1"
  fi

  # Create the bash script with shebang and set options
  echo '#!/usr/bin/env bash' > "$filename"
  echo 'set -euo pipefail' >> "$filename"

  # Make the script executable if -x flag was provided
  if [ "$make_executable" = true ]; then
      chmod +x "$filename"
      echo "Bash script '$filename' created and made executable."
  else
      echo "Bash script '$filename' created."
  fi
}

# A workaround for a bug where yadm won't add files
# already in another git repo (probably a git issue).
#
# https://github.com/TheLocehiliosan/yadm/issues/361
#
# Run this from the base dir with the conflicting .git/ in it.
# Example:
#   ~/.oh-my-zsh $ myscript yadm-force-add custom/plugins/install.sh
yadm-force-add() {

  # Must be in the root git dir.
  if [[ ! -d ".git" ]]; then
      echo
      echo "Run from the conflicted .git repo base dir."
      echo "(I'm looking for a .git/ dir.)"
      echo
      return 1
  fi

  tmpdir=/tmp/tmp.git

  if [[ -d $tmpdir ]]; then
      echo
      echo "Yo the temp dir already exists. Did I crash?"
      echo "Please reconcile: $tmpdir"
      echo
      return 1
  fi

  # Git is just files.
  # So just move the .git dir away for a second.
  mv .git $tmpdir

  # yadm will respect the other repo's .gitignore file
  # so be sure to move that too.
  tmpignore=/tmp/tmp.gitignore

  if [[ -e ".gitignore" ]]; then
      mv .gitignore $tmpignore
  fi

  # Should work now.
  yadm add "$1"

  # Put the .git dir back.
  mv $tmpdir .git

  # Put the .gitignore back (if it existed).
  if [[ -e $tmpignore ]]; then
      mv $tmpignore .gitignore
  fi

  # Show the yadm status, hopefully with a successfully added file.
  yadm status
}

