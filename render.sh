#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Handle cleaning mode
if [ "$1" = "--clean" ] || [ "$1" = "--clean-all" ] || [ "$1" = "--hard-clean" ]; then
    echo "=== Cleaning Project Build Artifacts ==="
    
    if [ "$1" = "--clean-all" ] || [ "$1" = "--hard-clean" ]; then
        echo "Removing root _site, .quarto, and _freeze directories (forcing full re-computation)..."
        rm -rf _site .quarto _freeze
    else
        echo "Removing root _site and .quarto directories (preserving _freeze cache)..."
        rm -rf _site .quarto
    fi

    echo "Clean complete!"
    exit 0
fi

echo "Building entire Quarto website..."
quarto render

echo "All files rendered successfully!"
