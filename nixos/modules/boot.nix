{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    tmp.cleanOnBoot = true;
    supportedFilesystems = [
      "ntfs"
      "ntfs3"
      "exfat"
      "ext4"
      "ext3"
      "ext2"
      "vfat"
      "fat32"
      "f2fs"
      "xfs"
      "jfs"
      "hfs"
      "hfsplus"
    ];
    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "i915.fastboot=1"
      "usbcore.autosuspend=-1"
    ];
    initrd = {
      verbose = false;
    };
    consoleLogLevel = 0;
    plymouth = {
      enable = true;
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
