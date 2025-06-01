{ config, pkgs, ... }: {

  imports = [
    ./database/mysql.nix
    # ./database/postgres.nix
  ];

  services = {
    udev.extraRules = ''
      # Disable "KEY_SWITCHVIDEOMODE"
      SUBSYSTEM=="input", ATTRS{name}=="Video Bus", ATTRS{phys}=="LNXVIDEO/video/input0", ATTRS{id}=="PNP0A08:00/device:13/LNXVIDEO:01", ENV{ID_INPUT_KEY}="0"

      # Disable Ghost touch on the touchscreen
      SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen*", ENV{LIBINPUT_PALM_PRESSURE_THRESHOLD}="200"
      ACTION=="add", SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_CALIBRATION_MATRIX}="1 0 0 0 1 0"

      SUBSYSTEM=="usb", ATTRS{idVendor}=="04f3", ATTRS{idProduct}=="2706", ATTR{authorized}="0"
    '';
    xserver = {
      enable = true;
      wacom.enable = false;
      excludePackages = [ pkgs.xterm ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    tailscale.enable = true;

    # ollama = {
    #   enable = true;
    #   acceleration = "cuda";
    # };
    # open-webui.enable = true;

    # Enable CUPS to print documents.
    printing.enable = false;
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "server string" = "NixOS Samba Server";
          "server role" = "standalone server";
          "guest account" = "nobody";
          "map to guest" = "bad user";

          # Apple-specific protocol extensions
          "fruit:aapl" = "yes";
          "fruit:nfs_aces" = "no";
          "fruit:metadata" = "stream";
          "fruit:model" = "MacSamba";
          "fruit:posix_rename" = "yes";
          "fruit:veto_appledouble" = "no";
          "fruit:wipe_intentionally_left_blank_rfork" = "yes";
          "fruit:delete_empty_adfiles" = "yes";

          security = "user";
        };
        public = {
          path = "/home/santhosh/iphone";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "santhosh";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };
  };
}
