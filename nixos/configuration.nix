{ config, lib, pkgs, vars, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Modules
      ./modules/env.nix
      ./modules/tlp.nix
      ./modules/nix.nix
      ./modules/i18n.nix
      ./modules/services
      ./modules/boot.nix
      ./modules/fonts.nix
      ./modules/sound.nix
      ./modules/docker.nix
      ./modules/aliases.nix
      ./modules/hardware.nix
      ./modules/bluetooth.nix
      ./modules/networking.nix

      # Desktop env
      ./modules/desktop-env/sway.nix

      # gpu
      ./modules/gpu/intel.nix
      # ./modules/gpu/nvidia.nix
    ];

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  stylix = {
    image = vars.wallpaper;
    polarity = "dark";
    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 32;
    };
  };

  users.users.${vars.user.name} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "docker"
      "libvirtd"
      "disk"
      "storage"
      "plugdev"
      "video"
    ];
  };
  system.stateVersion = "24.11";
}

