{ pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services = {
    udisks2.enable = true;

    udev.extraRules = ''
      SUBSYSTEM=="input", ATTRS{name}=="Video Bus", KERNEL=="event1", ENV{LIBINPUT_IGNORE_DEVICE}="1"

      # Disable ghost touch on the touchscreen
      SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen*", ENV{LIBINPUT_PALM_PRESSURE_THRESHOLD}="200"
      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_CALIBRATION_MATRIX}="1 0 0 0 1 0"

      SUBSYSTEM=="usb", ATTRS{idVendor}=="04f3", ATTRS{idProduct}=="2706", ATTR{authorized}="0"
    '';

    # Keyboard layout — Wayland-native (sway reads xkb settings via libinput)
    xserver = {
      enable = true;
      wacom.enable = false;
      excludePackages = [ pkgs.xterm ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
