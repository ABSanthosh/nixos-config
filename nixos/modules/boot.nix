{ pkgs, config, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
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
    ];

    kernelPackages = pkgs.linuxPackages_zen;
    # kernelModules = [
    #   # Virtual Camera
    #   "v4l2loopback"
    #   # Virtual Microphone, built-in
    #   "snd-aloop"
    # ];

    # extraModprobeConfig = ''
    #   options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    # '';

    # extraModulePackages = with config.boot.kernelPackages; [
    #   v4l2loopback
    # ];

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
