{
  pkgs,
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

  services = {
    # COMMENT THIS OUT - let nvidia.nix handle videoDrivers
    # xserver.videoDrivers = lib.mkBefore [ "intel" ];

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_TABLET_TOOL_PROXIMITY_THRESHOLD}="50"
      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen", ENV{LIBINPUT_TOUCH_ARBITRATION_ENABLED}="0"
    '';
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
}
