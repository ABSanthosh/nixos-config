{ ... }: {
  hardware = {
    enableRedistributableFirmware = true; # For some unfree drivers
    enableAllFirmware = true;
  };

  services = {
    udisks2.enable = true;
    dbus.enable = true;
  };
}
