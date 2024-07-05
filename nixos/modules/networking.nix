{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "zoro";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };
  };
}
