{ inputs, config, lib, pkgs, ... }: {
  imports =
    [
      ./hardware-configuration.nix

      # modules
      ./modules/i18n.nix
      ./modules/tlp.nix
      ./modules/nix.nix
      ./modules/boot.nix
      ./modules/fonts.nix
      ./modules/docker.nix
      ./modules/aliases.nix
      ./modules/hardware.nix
      ./modules/bluetooth.nix
      ./modules/variables.nix
      ./modules/networking.nix

      # gpu
      ./modules/gpu/intel.nix
      # ./modules/gpu/nvidia.nix

      # Desktop Env
      ./modules/desktop-env/gnome.nix
      # ./modules/desktop-env/sway.nix
      # ./modules/desktop-env/hyprland.nix

      # databases
      ./modules/database/mysql.nix
      # ./modules/database/postgres.nix

      # services
      ./modules/services/default.nix
    ];

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

   virtualisation = {
    libvirtd = {
      enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.santhosh = {
    isNormalUser = true;
    description = "Santhosh";
    extraGroups = [ "networkmanager" "wheel" "audio" "docker" "libvirtd" ];
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
