{ config, lib, pkgs, ... }:
let
  profile = "/etc/nixos/assets/santhosh";
  scripts = "/etc/nixos/scripts";
  username = "santhosh";
in
{
  system.activationScripts.script.text = ''
    # Set user photo: https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/4
    cp ${profile} /var/lib/AccountsService/icons/${username}
    # https://nixos.wiki/wiki/GNOME#Change_user.27s_profile_picture
    cp ${profile} ~/.face
  '';
}
