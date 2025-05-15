#!/usr/bin/env bash

MEM_FILE="/tmp/.prev_mem"
current=$(free | awk '/^Mem:/ {printf "%.0f", $3/1024}')

if [ -f "$MEM_FILE" ]; then
  prev=$(cat "$MEM_FILE")
else
  prev=$current
fi

delta=$((current - prev))
gib=$(awk "BEGIN {printf \"%.3f\", $current/1024}")

# Third line is color
# https://www.reddit.com/r/i3wm/comments/51rwo2/comment/d7ec6cc/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

if [ $delta -gt 0 ]; then
  echo "▲ ${gib} GiB"
  echo ""
  echo "#FF0000"
elif [ $delta -lt 0 ]; then
  echo "▼ ${gib} GiB"
  echo ""
  echo "#00FF00"
else
  echo "● ${gib} GiB"
  echo ""
  echo "#FFA500"
fi

echo $current >"$MEM_FILE"
