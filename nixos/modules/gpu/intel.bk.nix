{
  pkgs,
  lib,
  ...
}:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
      extraPackages = with pkgs; [
        vpl-gpu-rt
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        intel-compute-runtime
      ];
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Remove the nvidia blacklisting since we want it available
  # boot.extraModprobeConfig = lib.mkDefault ''
  #   blacklist nouveau
  #   options nouveau modeset=0
  # '';
  # boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  services = {
    xserver.videoDrivers = lib.mkBefore [ "intel" ]; # Intel first, nvidia second

    udev.extraRules = ''
      # # Remove NVIDIA USB xHCI Host Controller devices, if present
      # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # # Remove NVIDIA USB Type-C UCSI devices, if present
      # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # # Remove NVIDIA Audio devices, if present
      # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      
      # Remove NVIDIA VGA/3D controller devices
      # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"

      # Keep Nvidia GPU powered down until needed
      # Don't remove the device, just keep it in low power
      # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto"

      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_TABLET_TOOL_PROXIMITY_THRESHOLD}="50"
      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen", ENV{LIBINPUT_TOUCH_ARBITRATION_ENABLED}="0"
    '';
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
}
