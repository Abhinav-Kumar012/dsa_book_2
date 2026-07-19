#!/bin/bash
BASE="/home/work/.openclaw/workspace/dsa-book/src/chapters"

echo "Current new chapters:"
ls -1 "$BASE"/ch6[7-9]-*.md "$BASE"/ch7[0-9]-*.md "$BASE"/ch8[0-2]-*.md 2>/dev/null | wc -l
echo "Total chapters:"
ls -1 "$BASE"/ch*.md | wc -l
