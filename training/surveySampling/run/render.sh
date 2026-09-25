#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Target directory relative to src/chapter1/run
OUTPUT_DIR="."
mkdir -p "$OUTPUT_DIR"

# 1. Determine the rendering engine
ENGINE=$1

if [[ -z "$ENGINE" ]]; then
  echo "No rendering engine specified."
  read -p "Do you want to render with [r]markdown or [q]uarto? (r/q): " CHOICE
  case "$CHOICE" in 
    r|R ) ENGINE="r" ;;
    q|Q ) ENGINE="quarto" ;;
    * ) echo "Invalid choice. Exiting."; exit 1 ;;
  esac
fi

RMD_FILES=(
  "introductionSurveyStatisticsPublicHealth.Rmd"
  "probabilitySampling.Rmd"
  "probabilitySamplingCombinatorial.Rmd"
  "unbiasedEstimators.Rmd"
  "horvitzThompsonEstimator.Rmd"
)

for RMD_FILE in "${RMD_FILES[@]}"; do
  echo "=================================================="
  echo "Processing: $RMD_FILE"
  echo "=================================================="

  if [[ "$ENGINE" == "r" || "$ENGINE" == "R" ]]; then
    echo "Rendering HTML via rmarkdown::render()..."
    Rscript -e "rmarkdown::render(input = '$RMD_FILE', output_dir = '$OUTPUT_DIR')"
  elif [[ "$ENGINE" == "quarto" || "$ENGINE" == "q" ]]; then
    echo "Rendering HTML via quarto render..."
    quarto render "$RMD_FILE" --to html --output-dir "$OUTPUT_DIR" --embed-resources
  else
    echo "Unknown engine: $ENGINE. Please pass 'r' or 'quarto'."
    exit 1
  fi

  echo "=================================================="
  echo "Successfully generated HTML in $OUTPUT_DIR"
  echo "=================================================="
  echo ""
done

# Clean up redundant build artifacts and asset folders
echo "Cleaning up auxiliary build artifacts..."
rm -f .gitignore
rm -rf *_files/ *_cache/ .quarto/ .rmarkdown_data/

echo "Cleanup complete."
