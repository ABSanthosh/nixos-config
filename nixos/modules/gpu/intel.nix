{ config, pkgs, lib, ... }: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
      extraPackages = with pkgs; [
        vpl-gpu-rt
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };
  };
  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
  boot = {
    extraModprobeConfig = lib.mkDefault ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  };

  services = {
    xserver.videoDrivers = lib.mkForce [ "intel" ];
    udev.extraRules = ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA VGA/3D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"

      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_TABLET_TOOL_PROXIMITY_THRESHOLD}="50"
      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen", ENV{LIBINPUT_TOUCH_ARBITRATION_ENABLED}="0"
    '';
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
}
