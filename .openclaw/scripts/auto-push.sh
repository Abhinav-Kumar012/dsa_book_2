#!/bin/bash
# Auto-push script for dsa_book_2
# Runs via cron every 10 minutes

set -euo pipefail

cd /home/work/.openclaw/workspace/dsa_book_2

BRANCH=$(git rev-parse --abbrev-ref HEAD)
AHEAD=$(git log --oneline "origin/${BRANCH}..HEAD" 2>/dev/null | wc -l)

if [ "$AHEAD" -gt 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Pushing ${AHEAD} commits on ${BRANCH}..."
    git push origin "${BRANCH}" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Push complete."
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Nothing to push."
fi
