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
    initrd.verbose = false;
    consoleLogLevel = 0;
  };
}
