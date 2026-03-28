{ vars, config, ... }:
{
  networking = {
    hostName = vars.user.host;
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    wireless = {
      enable = false;
      iwd.enable = true;
    };

    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        445
        139
        22
      ];
      allowedUDPPorts = [
        137
        138
        config.services.tailscale.port
      ];
      allowedTCPPortRanges = [
        {
          from = 3000;
          to = 9999;
        }
      ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  services = {
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
          path = "${vars.user.home}/iphone";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = vars.user.name;
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };
  };
}
