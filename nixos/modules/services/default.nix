{ config, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
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
