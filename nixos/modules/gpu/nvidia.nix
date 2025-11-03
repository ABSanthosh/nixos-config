{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Define your GPU driver choice here
  gpuDriver = "nvidia"; # or "nouveau"

  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.stable;

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
    initrd.kernelModules = if gpuDriver == "nvidia" then [ "nvidia" ] else [ "nouveau" ];
    kernelModules = if gpuDriver == "nvidia" then [ "nvidia" ] else [ "nouveau" ];
    kernelParams =
      if gpuDriver == "nvidia" then
        [ "nouveau.modeset=0" ]
      else
        [
          "nouveau.modeset=1"
          "nouveau.config=NvForcePost=1"
          "nouveau.noaccel=0"
        ];
    blacklistedKernelModules =
      if gpuDriver == "nvidia" then
        [ "nouveau" ]
      else
        [
          "nvidia"
          "nvidia_uvm"
          "nvidia_drm"
          "nvidia_modeset"
        ];
  };

  hardware = {
    graphics.enable = true;
    graphics.extraPackages = with pkgs; [ mesa ];

    # Only enable NVIDIA-specific options if using proprietary drivers
    nvidia = lib.mkIf (gpuDriver == "nvidia") {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
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

  # For offloading, `modesetting` is needed additionally,
  # otherwise the X-server will be running permanently on nvidia,
  # thus keeping the GPU always on
  services.xserver.videoDrivers = [
    "modesetting"
    gpuDriver
  ];

  # Optionally install the offload script only if NVIDIA is used
  environment.systemPackages = lib.optional (gpuDriver == "nvidia") nvidia-offload;
}
