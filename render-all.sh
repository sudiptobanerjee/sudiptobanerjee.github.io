#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Optional clean flag: ./render-all.sh --clean
if [ "$1" = "--clean" ]; then
    echo "Cleaning build artifacts..."
    rm -rf _site .quarto 
fi

# Enable recursive matching (**) and handle cases where no .qmd files are found
shopt -s globstar nullglob

echo "Starting render process for all .qmd files..."

for f in **/*.qmd; do
  # Skip files in hidden folders (e.g., .quarto) or the output folder (_site)
  if [[ "$f" == _site/* ]] || [[ "$f" == .quarto/* ]]; then
    continue
  fi

  echo "Checking: $f"
  quarto render "$f"
done

echo "All files rendered successfully!"

