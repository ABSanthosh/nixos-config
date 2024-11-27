{ config, pkgs, lib, ... }: {
  boot = {
    kernelModules = [ "nouveau" ];
    kernelParams = lib.mkDefault [ "i915.modeset=0" ];
    blacklistedKernelModules = lib.mkDefault [ "nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset" "i915" ];
  };
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        mesa.drivers
      ];
    };
  };
  services = {
    xserver = {
      videoDrivers = lib.mkForce [ "nouveau" ]; #nvidia
    };
  };

  # environment.etc."modprobe.d/nouveau.conf".text = ''
  #   options nouveau modeset=1
  # '';
}
