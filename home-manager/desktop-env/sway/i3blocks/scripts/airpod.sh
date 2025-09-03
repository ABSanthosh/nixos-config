#!/usr/bin/env bash

# i3blocks bluetooth module
# Requirements: bluetoothctl, awk, grep, sed

BLUE_ICON=""
BLUE_COLOR="#268bd2" # Solarized blue

# Left click: toggle bluetooth
if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    STATUS=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
    if [[ "$STATUS" == "yes" ]]; then
        bluetoothctl power off >/dev/null
    else
        bluetoothctl power on >/dev/null
    fi
fi

# Get Bluetooth status
STATUS=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$STATUS" == "yes" ]]; then
    # Check connected devices
    DEVICE_INFO=$(bluetoothctl info | grep "Name:" | sed 's/^\s*Name: //')
    if [[ -n "$DEVICE_INFO" ]]; then
        # Device connected → show icon + name in blue
        echo "%{F$BLUE_COLOR}$BLUE_ICON $DEVICE_INFO%{F-}"
        echo "%{F$BLUE_COLOR}$BLUE_ICON $DEVICE_INFO%{F-}"
        echo "#268bd2"
    else
        # Bluetooth on, no device connected
        echo "$BLUE_ICON"
        echo "$BLUE_ICON"
        echo ""
    fi
else
    # Bluetooth off
    echo "$BLUE_ICON off"
    echo "$BLUE_ICON off"
    echo "#dc322f"  # red when off
fi
