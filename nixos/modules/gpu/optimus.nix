{ config, lib, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Enable power management (recommended for laptops)
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (for newer GPUs)
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Optimus Prime configuration
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus ID of the Intel GPU. You can find it using `lspci`
      intelBusId = "PCI:0:2:0";
      # Bus ID of the NVIDIA GPU. You can find it using `lspci`
      nvidiaBusId = "PCI:1:0:0";
    };

    # Use the appropriate driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    };
  };
}
