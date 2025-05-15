{ pkgs }:
let
  # List of scripts to install
  scriptNames = [
    "brightness"
    "memory"
    "volume"
    "battery"
    "wifi"
  ];

  # Function to generate a writeTextFile for each script
  mkScript =
    name:
    pkgs.writeTextFile {
      name = name;
      destination = "/bin/i3blocks/${name}";
      executable = true;
      text = builtins.readFile (./scripts + "/${name}.sh");
    };

  # Generate an attribute set with script names as keys and paths as values
  scripts = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = mkScript name;
    }) scriptNames
  );
in
pkgs.writeTextFile {
  name = "i3blocks-conf";
  text = ''
    [wifi]
    command=${scripts.wifi}/bin/i3blocks/wifi
    interval=5

    [battery]
    command=${scripts.battery}/bin/i3blocks/battery
    interval=5

    [volume]
    command=${scripts.volume}/bin/i3blocks/volume
    signal=1
    interval=5

    [brightness]
    command=${scripts.brightness}/bin/i3blocks/brightness
    color=#FFFF00
    interval=once
    signal=10

    [memory]
    command=${scripts.memory}/bin/i3blocks/memory
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
