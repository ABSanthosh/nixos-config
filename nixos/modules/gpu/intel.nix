{ config, pkgs, lib, ... }: {
  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };
  environment = {
    variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
  boot = {
    initrd.kernelModules = [ "i915" ];
    extraModprobeConfig = lib.mkDefault ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    # blacklistppedKernelModules = lib.mkDefault [ "nouveau" "nvidia" ];
  };

  services = {
    xserver.videoDrivers = lib.mkForce [ "intel" ];
    # udev.extraRules = lib.mkDefault ''
    #   # Remove NVIDIA USB xHCI Host Controller devices, if present
    #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

    #   # Remove NVIDIA USB Type-C UCSI devices, if present
    #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

    #   # Remove NVIDIA Audio devices, if present
    #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

    #   # Remove NVIDIA VGA/3D controller devices
    #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"

    #   ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="Video Bus", RUN+="/bin/sh -c 'echo 0 > /sys$env{DEVPATH}/inhibited'"
    # '';
  };
}
