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
      # Allow for Samba/CIFS file sharing
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
        } # Allows all ports in this range
      ];

      trustedInterfaces = [ "tailscale0" ];
    };
  };
}
