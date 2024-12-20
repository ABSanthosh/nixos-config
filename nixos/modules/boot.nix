{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    # kernelPackages = pkgs.linuxPackages_zen;
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
      "elevator=noop"
      "fastboot"

      # Fix for the Asus Zenbook
      # "acpi_osi=!"
      # "acpi_osi=Linux"
      # "i915.enable_psr=0"
      # "asus.use_lid_flip_devid=1"

      # "video.use_native_backlight=1" # Use native backlight instead of ACPI
      # "acpi_backlight=native"
    ];
    initrd = {
      verbose = false;
    };
    consoleLogLevel = 0;
    plymouth = {
      enable = true;
    };
    # blacklistedKernelModules = [ "video" ];
    # "acpi_video0"
    # extraModprobeConfig = ''
    #   options asus-nb-wmi use_kbd_backlight=0 dmi_check=0
    # '';
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
