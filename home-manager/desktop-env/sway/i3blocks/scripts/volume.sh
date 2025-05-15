#!/usr/bin/env bash

# Get the default audio sink's volume and mute status
info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo "$info" | awk '{print int($2 * 100)}')
muted=$(echo "$info" | grep -q MUTED && echo "yes" || echo "no")

if [ "$muted" = "yes" ]; then
  echo "♪ ${volume}% (Muted)"
  echo ""
  echo "#FFFF00" # Red for muted
else
  echo "♪ ${volume}%"
fi
