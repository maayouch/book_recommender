#!/usr/bin/env bash
# Download the Goodbooks-10k dataset into data/
# Source: https://github.com/zygmuntz/goodbooks-10k
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p data

BASE="https://raw.githubusercontent.com/zygmuntz/goodbooks-10k/master"
for f in books.csv ratings.csv tags.csv book_tags.csv; do
  echo "Downloading $f..."
  curl -fsSL -o "data/$f" "$BASE/$f"
done

echo "Done: files saved in data/"
