{ pkgs }: {
  swaybar-cmd = pkgs.writeTextFile {
    name = "swaybar-cmd";
    destination = "/bin/swaybar-cmd";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      get_mem_info() {
        free | awk '/^Mem:/ {printf "%.0f", $3/1024}'
      }

      prev_mem_info=$(get_mem_info)

      format_mem_info() {
        local curr_mem_info=$(get_mem_info)
        local gib_format=$(echo $curr_mem_info | awk '{printf "%.3f", $1/1024}')

        # if memory delta is negative, then return "▼ {new_mem_info} GiB" in green
        # if memory delta is positive, then return "▲ {new_mem_info} GiB" in red
        # if memory delta is zero, then return "● {new_mem_info} GiB" in orange
        local mem_delta=$(($curr_mem_info - $prev_mem_info))

        # Escape interpolation: https://guergabo.substack.com/p/writing-a-bash-script-the-hard-waywith
        if [ $mem_delta -gt 0 ]; then
          # echo -e "''${RED}▲ ''${gib_format} GiB''${NC}"
          json="{ \"full_text\": \"▲ ''${gib_format} GiB\", \"color\": \"#FF0000\" }"
        elif [ $mem_delta -lt 0 ]; then
          # echo -e "''${GREEN}▼ ''${gib_format} GiB''${NC}"
          json="{ \"full_text\": \"▼ ''${gib_format} GiB\", \"color\": \"#00FF00\" }"
        else
          # echo -e "''${ORANGE}● ''${gib_format} GiB''${NC}"
          json="{ \"full_text\": \"● ''${gib_format} GiB\", \"color\": \"#FFA500\" }"
        fi

       json_array=$(update_holder holder__memory "$json") 
      }

      function update_holder {
        local instance="$1"
        local replacement="$2"
        echo "$json_array" | jq --argjson arg_j "$replacement" "(.[] | (select(.instance==\"$instance\"))) |= \$arg_j"
      }

      function remove_holder {
        local instance="$1"
        echo "$json_array" | jq "del(.[] | (select(.instance==\"$instance\")))"
      }

      function get_brightness {
        local brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
        local max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
        local percentage=$(expr $brightness \* 100 / $max_brightness)
        local json="{ \"full_text\": \"☀ $percentage%\", \"color\": \"#FFFF00\" }"
        json_array=$(update_holder holder__brightness "$json")
      }

      ${pkgs.i3status}/bin/i3status -c ${./swaybar.conf} | (
        read line
        echo "$line"
        read line
        echo "$line"
        read line
        echo "$line"
        read line
        echo "$line"
        while true; do
          read line
          json_array="$(echo $line | sed -e 's/^,//')"
          get_brightness
          format_mem_info
          echo ",$json_array"
          prev_mem_info=$(get_mem_info)
          # sleep 1
        done
      )
    '';
  };
}
