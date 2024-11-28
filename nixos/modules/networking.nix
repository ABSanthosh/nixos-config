{ vars, ... }: {
  networking = {
    hostName = vars.user.host;
    networkmanager = { 
      enable = true;
      wifi.powersave = true;
    };
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
    firewall = {
      enable = true;
      # Allow for Samba/CIFS file sharing
      allowedTCPPorts = [ 445 139 ];
      allowedUDPPorts = [ 137 138 ];
    };
  };
}
