#!/usr/bin/env bash

brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
percentage=$((brightness * 100 / max))

echo "☀ ''${percentage}%"
