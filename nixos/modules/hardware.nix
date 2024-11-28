{ ... }: {
  hardware = {
    enableRedistributableFirmware = true; # For some unfree drivers
  };

  services = {
    udisks2.enable = true;
    dbus.enable = true;
  };
}
