{ config, pkgs, ... }:

{
  hardware = {
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
}