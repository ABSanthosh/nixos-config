{ ... }:
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
  };
}
