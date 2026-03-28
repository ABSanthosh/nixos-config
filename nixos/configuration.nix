{ vars, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # System
    ./modules/nix.nix
    ./modules/i18n.nix
    ./modules/boot.nix
    ./modules/fhs-compat.nix

    # Hardware
    ./modules/hardware.nix
    ./modules/tlp.nix
    ./modules/gpu/intel.nix
    # ./modules/gpu/nvidia.nix

    # Desktop
    ./modules/fonts.nix
    ./modules/sound.nix
    ./modules/bluetooth.nix
    ./modules/desktop-env/sway.nix

    # Networking
    ./modules/networking.nix

    # Services
    ./modules/services/docker.nix
    ./modules/services/minecraft.nix
    # ./modules/services/tailscale.nix
    # ./modules/services/database/mysql.nix
    # ./modules/services/database/postgres.nix
  ];

  programs = {
    gamemode.enable = true;
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

  services.usbmuxd.enable = true;

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
      "usbmux"
    ];
  };
  system.stateVersion = "25.05";
}
