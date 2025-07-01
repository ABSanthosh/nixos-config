{ vars, ... }:
let
  # Helper function to map attributes to a list of key-value pairs
  mapAttrsToList = f: attrs: builtins.map (name: f name attrs.${name}) (builtins.attrNames attrs);

  # Generate Bluetooth aliases for connecting to devices
  # Commonly used Bluetooth devices are defined in `vars.bluetooth`
  generateBluetoothAliases =
    bluetooth:
    builtins.listToAttrs (
      mapAttrsToList (name: device: {
        name = "blue-${device."command-name"}";
        value = ''bluetoothctl <<< "connect ${device.address}"'';
      }) bluetooth
    );
in
{
  environment.shellAliases = {
    # https://github.com/Misterio77/nix-starter-configs#usage
    nix-refresh = "sudo nixos-rebuild switch --flake .#zoro";

    nix-garbage = "sudo nix-collect-garbage --delete-older-than 5d && nix-refresh";
    nix-list-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

    nix-update = "nix flake update";
    yy = "yazi";

    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  } // generateBluetoothAliases vars.bluetooth;
}
