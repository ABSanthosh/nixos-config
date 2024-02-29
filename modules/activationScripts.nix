{ config, lib, pkgs, ... }:
let
  profile = "/etc/nixos/assets/santhosh";
  scripts = "/etc/nixos/scripts";
  username = "santhosh";

  # scriptList = [ "OpenInCode.sh" ];
in
{
  system.activationScripts.script.text = ''
    # Set user photo: https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/4
    cp ${profile} /var/lib/AccountsService/icons/${username}
  '';
}
