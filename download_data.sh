#!/bin/bash
mkdir -p data
cd data
BASE=https://raw.githubusercontent.com/zygmuntz/goodbooks-10k/master
for f in books.csv ratings.csv tags.csv book_tags.csv; do
  curl -O "$BASE/$f"
done
