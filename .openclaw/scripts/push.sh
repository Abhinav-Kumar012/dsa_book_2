#!/bin/bash
# Push current branch to origin (one-shot)
# Usage: ./push.sh

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

BRANCH=$(git rev-parse --abbrev-ref HEAD)
AHEAD=$(git log --oneline "origin/${BRANCH}..HEAD" 2>/dev/null | wc -l)

if [ "$AHEAD" -eq 0 ]; then
    echo "Nothing to push."
    exit 0
fi

echo "Pushing ${AHEAD} commits on ${BRANCH}..."
git push origin "${BRANCH}"
echo "Done."
