{config, pkgs, lib, ...}: 
{
  imports = [
    ./gtk.nix
    ./dconf.nix
    ./packages.nix
    ./extensions.nix
  ];
}