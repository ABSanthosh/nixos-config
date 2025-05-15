{ pkgs }:
let
  # Brightness script
  conf_brightness = pkgs.writeTextFile {
    name = "brightness";
    destination = "/bin/i3blocks/brightness";
    executable = true;
    text = (builtins.readFile ./scripts/brightness.sh);
  };

  conf_memory = pkgs.writeTextFile {
    name = "memory";
    destination = "/bin/i3blocks/memory";
    executable = true;
    text = (builtins.readFile ./scripts/memory.sh);
  };

  conf_volume = pkgs.writeTextFile {
    name = "volume";
    destination = "/bin/i3blocks/volume";
    executable = true;
    text = (builtins.readFile ./scripts/volume.sh);
  };

  conf_battery = pkgs.writeTextFile {
    name = "battery";
    destination = "/bin/i3blocks/battery";
    executable = true;
    text = (builtins.readFile ./scripts/battery.sh);
  };

  conf_wifi = pkgs.writeTextFile {
    name = "wifi";
    destination = "/bin/i3blocks/wifi";
    executable = true;
    text = (builtins.readFile ./scripts/wifi.sh);
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
