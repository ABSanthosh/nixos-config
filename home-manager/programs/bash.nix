{ vars, ... }:
let
  generateBluetoothAliases =
    bluetooth:
    builtins.listToAttrs (
      builtins.map (name: {
        name = "blue-${bluetooth.${name}."command-name"}";
        value = ''bluetoothctl <<< "connect ${bluetooth.${name}.address}"'';
      }) (builtins.attrNames bluetooth)
    );
in
{
  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"
    '';
    shellAliases =
      {
        nix-refresh = "sudo nixos-rebuild switch --flake .#${vars.user.host}";
        nix-garbage = "sudo nix-collect-garbage --delete-older-than 5d && nix-refresh";
        nix-list-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        nix-packages = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u | less";
        nix-update = "nix flake update";

        yy = "yazi";
        captive = "route -n | awk '$1 == \"0.0.0.0\" {print $2}' | wl-copy";

        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
      }
      // generateBluetoothAliases vars.bluetooth;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
