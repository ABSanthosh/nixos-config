{ pkgs, ... }:
{
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
      "usbcore.autosuspend=-1"
      "elevator=noop"
      "fastboot"
      "i915.fastboot=1"
      "i915.enable_dpcd_backlight=0"
      "i915.force_probe=*"
      "video=DP-2:1920x1080@60"
      "video=DP-1:1920x1080@60"
    ];

    kernelPackages = pkgs.linuxPackages_zen;

    initrd = {
      verbose = false;

      # ADD THIS: Compress initrd more aggressively
      compressor = "zstd";
      compressorArgs = [
        "-19"
        "-T0"
      ];

      # CRITICAL: Don't include Nvidia in initrd - only Intel
      # Nvidia will be loaded later by the running system when needed
      availableKernelModules = [
        # Storage
        "nvme"
        "ahci"
        "xhci_pci"
        "thunderbolt"
        "sd_mod"
        "usb_storage"
        "usbhid"

        # Intel graphics ONLY in initrd
        "i915"

        # Network (if needed for boot)
        # "e1000e"
        # "iwlwifi"
      ];

      # Explicitly prevent Nvidia modules in initrd
      kernelModules = [ "i915" ]; # Only i915 in early boot
    };

    # Nvidia modules loaded AFTER boot by systemd
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    consoleLogLevel = 0;
    plymouth.enable = false;
  };

  systemd = {
    watchdog.rebootTime = "0";
    targets.network-online.wantedBy = pkgs.lib.mkForce [ ];
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online = {
        enable = false;
        wantedBy = pkgs.lib.mkForce [ ];
      };
    };
  };
}
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
