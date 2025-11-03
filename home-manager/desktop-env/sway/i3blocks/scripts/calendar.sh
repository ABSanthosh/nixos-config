#!/usr/bin/env bash

cAPPID="calendar"

if [[ "${BLOCK_BUTTON}" -eq 3 ]]; then
    # 1) Launch kitty popup in background
    kitty --class="$cAPPID" -e bash -lc "cal | sed \"s/\b\$(date +%-d)\b/\$(tput setaf 1)&\$(tput sgr0)/\";" &
    KITTY_PID=$!

    # 2) Monitor focus changes
    prev_focused=false
    swaymsg -m -t subscribe '["window"]' \
      | stdbuf -oL jq -c 'select(.change == "focus")' \
      | while read -r event; do
          current_app=$(echo "$event" | jq -r '.container.app_id // empty')
          if [[ "$current_app" == "$cAPPID" ]]; then
              prev_focused=true
          else
              if $prev_focused; then
                  # btmenu lost focus → kill kitty and exit loop
                  swaymsg "[app_id=\"$cAPPID\"] kill" >/dev/null
                  kill $KITTY_PID 2>/dev/null || true
                  break
              fi
          fi
      done &

    WATCHER_PID=$!

    # 3) Wait for kitty to exit and cleanup watcher
    wait $KITTY_PID
    kill $WATCHER_PID 2>/dev/null || true
fi

echo "$(date '+%A, %b %d, %Y')"