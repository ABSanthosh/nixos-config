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
    initrd.kernelModules = [ "i915" "nouveau" ];
    kernelModules = [ "i915" "nouveau" ];
    kernelParams = [
      "nouveau.modeset=1"
      "nouveau.config=NvForcePost=1"
      "nouveau.noaccel=0"

      # "video=HDMI-A-4:1920x1080@60eR"
      # "video=HDMI-A-4:pos:1920x0"

      # "video=eDP-1:3840x2160@60e" # Internal display
      # "video=HDMI-A-4:1080x1920@60eR" # External display in portrait mode
      # "video=HDMI-A-4:pos:420x1080" # Center below primary display
    ];
    blacklistedKernelModules = lib.mkDefault [ "nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset" ];
  };
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        mesa.drivers
      ];
    };

    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;

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
      videoDrivers = lib.mkForce [ "modesetting" "nouveau" ]; #nvidia
      # videoDrivers = lib.mkForce [ "nvidia" ]; #nvidia
    };
  };

}
