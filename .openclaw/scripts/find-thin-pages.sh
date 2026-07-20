#!/bin/bash
# Find thin markdown files (useful for expansion tasks)
# Usage: ./find-thin-pages.sh [min_lines] [max_lines]
# Defaults: 150-200 lines

MIN=${1:-150}
MAX=${2:-200}

cd "$(git rev-parse --show-toplevel)"
find src -name "*.md" -exec wc -l {} \; | sort -n | awk -v min="$MIN" -v max="$MAX" '$1 >= min && $1 <= max {print}'
