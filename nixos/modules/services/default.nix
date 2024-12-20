{ config, pkgs, ... }: {

  imports = [
    ./database/mysql.nix
    # ./database/postgres.nix
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };

    udev.extraRules = ''
        # # Disable the touchscreen on the laptop
        # SUBSYSTEM=="input", KERNEL=="event6", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # # Disable the video switch events from ASUS WMI
        # SUBSYSTEM=="input", ATTRS{name}=="Asus WMI hotkeys", ATTRS{phys}=="asus-nb-wmi/video", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # # Disable the ELAN stylus completely
        # SUBSYSTEM=="input", ATTRS{name}=="ELAN Touchscreen Stylus", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # SUBSYSTEM=="input", ATTRS{id/vendor}=="04f3", ATTRS{id/product}=="2706", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # SUBSYSTEM=="input", KERNEL=="event1", ATTRS{name}=="Video Bus", ENV{LIBINPUT_IGNORE_DEVICE}="1"
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
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        server string = NixOS Samba Server
        server role = standalone server
        guest account = nobody
        map to guest = bad user
        
        # Apple-specific protocol extensions
        fruit:aapl = yes
        fruit:nfs_aces = no
        fruit:metadata = stream
        fruit:model = MacSamba
        fruit:posix_rename = yes 
        fruit:veto_appledouble = no
        fruit:wipe_intentionally_left_blank_rfork = yes
        fruit:delete_empty_adfiles = yes
      '';
      shares = {
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
