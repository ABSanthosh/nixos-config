{ pkgs }:
let
  # Brightness script
  conf_brightness = pkgs.writeTextFile {
    name = "brightness";
    destination = "/bin/i3blocks/brightness";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
      max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
      percentage=$((brightness * 100 / max))

      echo "☀ ''${percentage}%"
    '';
  };

  conf_memory = pkgs.writeTextFile {
    name = "memory";
    destination = "/bin/i3blocks/memory";
    executable = true;
    text = ''
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
        echo "▲ ''${gib} GiB"
        echo ""
        echo "#FF0000"
      elif [ $delta -lt 0 ]; then
        echo "▼ ''${gib} GiB"
        echo ""
        echo "#00FF00"
      else
        echo "● ''${gib} GiB"
        echo ""
        echo "#FFA500"
      fi

      echo $current >"$MEM_FILE"
    '';
  };

  conf_volume = pkgs.writeTextFile {
    name = "volume";
    destination = "/bin/i3blocks/volume";
    executable = true;
    text = ''
      # Get the default audio sink's volume and mute status
      info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
      volume=$(echo "$info" | awk '{print int($2 * 100)}')
      muted=$(echo "$info" | grep -q MUTED && echo "yes" || echo "no")

      if [ "$muted" = "yes" ]; then
        echo "♪ ''${volume}% (Muted)"
        echo ""
        echo "#FFFF00"   # Red for muted
      else
        echo "♪ ''${volume}%"
      fi
    '';
  };

  conf_battery = pkgs.writeTextFile {
    name = "battery";
    destination = "/bin/i3blocks/battery";
    executable = true;
    text = ''
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
    '';
  };

  conf_wifi = pkgs.writeTextFile {
    name = "wifi";
    destination = "/bin/i3blocks/wifi";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # if the machine has no battery or wireless
      # connection (think desktop), the corresponding block should not be displayed.
      # [[ ! -d /sys/class/net/''${INTERFACE}/wireless ]] && exit

      if [[ -z "$INTERFACE" ]]; then
        INTERFACE="''${BLOCK_INSTANCE: -wlan0}"
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
      echo "W: (''${QUALITY}% at ''${SSID}, ''${BITRATE}) ''${IP_ADDR}"
      echo ""
      echo "#02F301"
    '';
  };

in
pkgs.writeTextFile {
  name = "i3blocks-conf";
  text = ''
    [wifi]
    command=${conf_wifi}/bin/i3blocks/wifi
    interval=5

    [battery]
    command=${conf_battery}/bin/i3blocks/battery
    interval=5

    [volume]
    command=${conf_volume}/bin/i3blocks/volume
    signal=1
    interval=5

    [brightness]
    command=${conf_brightness}/bin/i3blocks/brightness
    color=#FFFF00
    interval=once
    signal=10

    [memory]
    command=${conf_memory}/bin/i3blocks/memory
    interval=5

    [date]
    command=date '+%A, %b %d, %Y'
    interval=60

    [time]
    command=date '+%I:%M %p'
    interval=5
  '';
}

# To remove the red frown
# # Remove from ~/.icons
# rm -rf ~/.icons/default
# rm -rf ~/.icons/phinger-cursors-light

# # Remove from ~/.local/share/icons
# rm -rf ~/.local/share/icons/default
# rm -rf ~/.local/share/icons/phinger-cursors-light