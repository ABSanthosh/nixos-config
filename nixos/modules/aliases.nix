{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.shellAliases = {
    nix-garbage = "sudo nix-collect-garbage && sudo nix-env --delete-generations +5 && sudo nixos-rebuild switch";
    nix-clear = "sudo nix profile wipe-history --profile /nix/var/nix/profile/system --older-than 5d && sudo nixos-rebuild switch";

    # https://github.com/Misterio77/nix-starter-configs#usage
    nix-refresh = "sudo nixos-rebuild switch --flake .#zoro";
    nix-update = "nix flake update";
    yy = "yazi";

    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    "......" = "cd ../../../../../";
  };
}
