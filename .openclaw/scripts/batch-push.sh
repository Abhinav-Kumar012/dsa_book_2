#!/bin/bash
# batch_push.sh — Pushes local commits every 15 minutes
cd /home/work/.openclaw/workspace/dsa_book_2

export GITHUB_TOKEN=$(cat /home/work/.openclaw/workspace/.openclaw/tmp/token.txt | tr -d '\n')

while true; do
  sleep 900  # 15 minutes
  
  UNPUSHED=$(git log origin/openclaw/autonomous-book..HEAD --oneline 2>/dev/null | wc -l)
  
  if [ "$UNPUSHED" -gt 0 ]; then
    echo "[$(date)] Pushing $UNPUSHED local commits..."
    git push origin openclaw/autonomous-book 2>&1
    if [ $? -eq 0 ]; then
      echo "[$(date)] Push successful"
    else
      echo "[$(date)] Push failed, will retry next cycle"
    fi
  else
    echo "[$(date)] No unpushed commits"
  fi
done
