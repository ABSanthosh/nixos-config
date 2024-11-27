{ config, pkgs, ...}:
{
    imports = [
        ./gtk.nix
        ./dconf.nix
        ./packages.nix
        ./extensions.nix
    ];
}