{ config, pkgs, lib, ... }:
let
  nvidiaDriverChannel =
    config.boot.kernelPackages.nvidiaPackages.latest; # stable, latest, etc.

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  boot = {
    kernelParams = lib.mkDefault [ "i915.modeset=0" ];
    blacklistedKernelModules = lib.mkDefault [ "i915" ];
  };
  environment.systemPackages = [ nvidia-offload ];
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };
    nvidia = {
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      package = nvidiaDriverChannel;
      powerManagement = {
        enable = true;
        finegrained = false;
      };

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
  services = {
    xserver = {
      videoDrivers = lib.mkForce [ "nvidia" ];
    };
  };
}
