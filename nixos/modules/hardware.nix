{ config, pkgs, lib, ... }:

{
  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams =
      lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
        "nvidia-drm.modeset=1"
        "nvidia_drm.fbdev=1"
      ];
  };

  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };

  hardware = {
    enableRedistributableFirmware = true; # For some unfree drivers

    opengl = {
      enable = true;
      # driSupport = true;
      # driSupport32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };

    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      powerManagement = {
        enable = false;
        finegrained = false;
      };

      prime = {
        # sync.enable = true;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    xserver = {
      videoDrivers = [
        "nvidiaBeta" # nvidia should work fine as well
      ];
    };
  };
}
