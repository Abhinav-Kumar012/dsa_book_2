#!/bin/bash
# Auto-push daemon - checks every N minutes and pushes if there are unpushed commits
# Usage: nohup bash auto-push-daemon.sh [interval_seconds] &
# Default: 600s (10 min)

set -euo pipefail
REPO="$(git rev-parse --show-toplevel 2>/dev/null || echo /home/work/.openclaw/workspace/dsa_book_2)"
LOG="$REPO/.openclaw/logs/auto-push.log"
INTERVAL="${1:-600}"
mkdir -p "$(dirname "$LOG")"

echo "[$(date)] Auto-push daemon started (interval: ${INTERVAL}s)" >> "$LOG"

while true; do
    cd "$REPO"
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    AHEAD=$(git log --oneline "origin/${BRANCH}..HEAD" 2>/dev/null | wc -l)

    if [ "$AHEAD" -gt 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Pushing ${AHEAD} commits on ${BRANCH}..." >> "$LOG"
        if git push origin "${BRANCH}" >> "$LOG" 2>&1; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Push OK" >> "$LOG"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] Push FAILED (will retry)" >> "$LOG"
        fi
    fi
    sleep "$INTERVAL"
done
