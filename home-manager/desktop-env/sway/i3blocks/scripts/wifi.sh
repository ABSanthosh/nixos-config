#!/usr/bin/env bash

# if the machine has no battery or wireless
# connection (think desktop), the corresponding block should not be displayed.
# [[ ! -d /sys/class/net/''${INTERFACE}/wireless ]] && exit

if [[ -z "$INTERFACE" ]]; then
  INTERFACE="${BLOCK_INSTANCE: -wlan0}"
fi

# Extract signal strength in dBm from iw
signal=$(iw dev wlan0 link | awk '/signal:/ {print $2}')

# If no signal found, exit
if [[ -z "$signal" ]]; then
  echo "W: down"
  echo ""
  echo "#FF0000"
fi

# Constants from C code
NOISE_FLOOR_DBM=-90
SIGNAL_MAX_DBM=-20

# Clamp signal within bounds
if ((signal < NOISE_FLOOR_DBM)); then
  signal=$NOISE_FLOOR_DBM
elif ((signal > SIGNAL_MAX_DBM)); then
  signal=$SIGNAL_MAX_DBM
fi

# Ref: https://github.com/i3/i3status/blob/d53da19a79d68b1dc9abdb953c3d2e0497b33a7a/src/print_wireless_info.c#L477
# Calculate quality as percent using the same formula
QUALITY=$(awk -v s="$signal" -v max="$SIGNAL_MAX_DBM" -v min="$NOISE_FLOOR_DBM" 'BEGIN {
          q = 100 - 70 * ((max - s) / (max - min));
          if (q > 100) q = 100;
          if (q < 0) q = 0;
          printf "%.0f\n", q;
      }')

IFACE=$(ip route | awk '/^default/ { print $5; exit }')
IP_ADDR=$(ip -4 addr show "$IFACE" | awk '/inet / { print $2 }' | cut -d/ -f1)
SSID=$(iw dev "$IFACE" link | awk -F': ' '/SSID/ {print $2}')
BITRATE=$(iw dev wlan0 link | awk -F': ' '/rx bitrate/ { print $2 }' | awk '{ print $1, $2 }')

# W: ( 73% at MP-312, 14.4 Mb/s) 10.0.0.36
echo "W: (${QUALITY}% at ${SSID}, ${BITRATE}) ${IP_ADDR}"
echo ""
echo "#02F301"
