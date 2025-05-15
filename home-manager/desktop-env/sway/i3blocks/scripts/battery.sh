#!/usr/bin/env bash

# Get battery info from acpi
output=$(acpi -b | grep '^Battery 0:')

# Extract status and percentage
status=$(echo "$output" | awk -F': |, ' '{print $2}')
percentage=$(echo "$output" | awk -F', ' '{print $2}' | tr -d ' %')

# Set icon or symbol based on status
case "$status" in
Charging)
  symbol="CHR"
  color="#00FF00" # green
  ;;
Discharging)
  symbol="BAT"
  # Optional: color based on charge level
  if [ "$percentage" -le 20 ]; then
    color="#FF0000" # red
  elif [ "$percentage" -le 50 ]; then
    color="#FFA500" # orange
  else
    color=""
  fi
  ;;
Full)
  symbol="FULL"
  color="#00FFFF" # cyan
  ;;
*)
  symbol="IDLE"
  color="#CCCCCC" # gray
  ;;
esac

# Output text and color
echo "$symbol $percentage%"
echo ""
echo "$color"
