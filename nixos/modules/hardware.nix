{ config, pkgs, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware = {
    enableRedistributableFirmware = true; # For some unfree drivers

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

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
