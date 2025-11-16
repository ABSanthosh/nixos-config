#!/usr/bin/env bash

# i3blocks bluetooth module
# Requirements: bluetoothctl, awk, grep, sed

BLUE_ICON=""
BLUE_COLOR="#0082FC" 
APPID="btmenu"

# Left click: toggle bluetooth
if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    STATUS=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
    if [[ "$STATUS" == "yes" ]]; then
        bluetoothctl power off >/dev/null
    else
        bluetoothctl power on >/dev/null
    fi
# Right click: open bluetooth device selector
elif [[ "${BLOCK_BUTTON}" -eq 3 ]]; then
    # 1) Launch kitty popup in background
    kitty --class="$APPID" -e bash -lc '
      CHOICE=$(bluetoothctl devices | awk "{print \$2, substr(\$0, index(\$0,\$3))}" | fzf --prompt="Select device: ")
      if [[ -n "$CHOICE" ]]; then
        MAC=$(echo "$CHOICE" | awk "{print \$1}")
        bluetoothctl connect "$MAC"
      fi
    ' &
    KITTY_PID=$!

    # 2) Monitor focus changes
    prev_focused=false
    swaymsg -m -t subscribe '["window"]' \
      | stdbuf -oL jq -c 'select(.change == "focus")' \
      | while read -r event; do
          current_app=$(echo "$event" | jq -r '.container.app_id // empty')
          if [[ "$current_app" == "$APPID" ]]; then
              prev_focused=true
          else
              if $prev_focused; then
                  # btmenu lost focus → kill kitty and exit loop
                  swaymsg "[app_id=\"$APPID\"] kill" >/dev/null
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

# Get Bluetooth status
STATUS=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$STATUS" == "yes" ]]; then
    # Check connected devices
    DEVICE_INFO=$(bluetoothctl info | grep "Name:" | sed 's/^\s*Name: //')
    if [[ -n "$DEVICE_INFO" ]]; then
        # Device connected → show icon + name in blue
        echo "$BLUE_ICON $DEVICE_INFO"
        echo "$BLUE_ICON $DEVICE_INFO"
        echo "#268bd2"
    else
        # Bluetooth on, no device connected
        echo "$BLUE_ICON on"
        echo "$BLUE_ICON on"
        echo ""
    fi
else
    # Bluetooth off
    echo "$BLUE_ICON off"
    echo "$BLUE_ICON off"
    echo "#dc322f"  # red when off
fi