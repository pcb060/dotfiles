#!/usr/bin/env bash

set -euo pipefail

echo "Executing pkginstaller.sh on folder $1"
for file in "$1"/*; do
  case "$file" in
    *.apt)
      echo "  Installing packages in "$file" using apt..."
      sudo apt install -y $(egrep --invert-match "^(#|$)" "$file")
      ;;
    *.snap)
      echo "  Installing packages in "$file" using snap..."
      while IFS= read -r pkg; do sudo snap install "$pkg"; done < "$file" 
      ;;
    *.sh)
      echo "  Installing package by executing shell script "$file"..."
      "$file"
      ;;
    *)
      echo "  Skipping unrecognized file type: $file"
      ;;
  esac
done
