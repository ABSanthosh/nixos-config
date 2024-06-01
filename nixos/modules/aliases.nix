{ config, lib, pkgs, ... }:
{
  environment.shellAliases = {
    nix-garbage = "sudo nix-collect-garbage && sudo nix-env --delete-generations +5 && sudo nixos-rebuild switch";
    nix-clear = "sudo nix profile wipe-history --profile /nix/var/nix/profile/system --older-than 5d && sudo nixos-rebuild switch";
    nix-refresh = "sudo nixos-rebuild switch";
  };
}
