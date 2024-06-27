{ config, lib, pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" "exfat" ];
    kernelParams = [ "quiet" "splash" "loglevel=0" "intel_pstate=passive" "reboot=acpi" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      verbose = false;
    };
    consoleLogLevel = 0;
    plymouth = {
      enable = true;
    #   logo = /etc/nixos/assets/plymouth/logo.png;
    };
  };
  systemd = {
    watchdog.rebootTime = "0";
    targets.network-online.wantedBy = pkgs.lib.mkForce [ ]; # Normally ["multi-user.target"]
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online = {
        enable = false;
        wantedBy = pkgs.lib.mkForce [ ]; # Normally ["network-online.target"] 
      };
    };
  };
}
