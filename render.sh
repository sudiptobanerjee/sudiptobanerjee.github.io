#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Optional clean flag: ./render-all.sh --clean
if [ "$1" = "--clean" ]; then
    echo "Cleaning build artifacts..."
    rm -rf _site .quarto
fi

echo "Building entire Quarto website..."
quarto render

echo "All files rendered successfully!"

