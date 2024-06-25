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
  };

  services = {
    xserver = {
      videoDrivers = [
        "nvidiaBeta" # nvidia should work fine as well
      ];
    };
  };
}
