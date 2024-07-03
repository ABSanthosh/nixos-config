{ config, pkgs, ... }:

{
  imports = [ 
      ./hardware-configuration.nix

      # Modules
      ./modules/nix.nix
      ./modules/i18n.nix
      ./modules/boot.nix
      ./modules/aliases.nix
      ./modules/hardware.nix
      ./modules/bluetooth.nix
      ./modules/networking.nix


      # Services
      ./modules/services/sway.nix
      ./modules/services/default.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  users.users.santhosh = {
    isNormalUser = true;
    description = "Santhosh";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    packages = with pkgs; [ ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
