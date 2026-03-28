{
  config,
  pkgs,
  lib,
  ...
}:
let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.stable;
in
{
  boot = {
    kernelParams = [
      "nouveau.modeset=0"
      "nvidia-drm.modeset=1" # Add this for better power management
    ];

    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        # Add these for NVIDIA Vulkan:
        vulkan-loader
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        # 32-bit Vulkan support (critical for many games)
        vulkan-loader
        vulkan-validation-layers
      ];
    };

    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;

      # These are key for offload power management
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      package = nvidiaDriverChannel;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  environment.sessionVariables = {
    # Force Sway to use Intel GPU (card1)
    WLR_DRM_DEVICES = "/dev/dri/card1";
  };

  # Intel/modesetting FIRST, nvidia SECOND
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
}
