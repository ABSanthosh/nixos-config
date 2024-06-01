{ config, lib, pkgs, ... }:
{
  services.xserver = {
    # Enable the GNOME Desktop Environment.
    displayManager = {
      autoLogin = {
        enable = true;
        user = "santhosh";
      };
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  # Disable tracker 
  gnome.tracker.enable = false;
  gnome.tracker-miners.enable = false;

  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      baobab # disk usage analyzer
      epiphany # web browser
      # gedit # text editor
      simple-scan # document scanner
      yelp # help viewer
      geary # email client
      # seahorse # password manager

      pkgs.gnome-tour
      gnome-characters
      gnome-logs
      gnome-maps
      gnome-music
      gnome-weather
      gnome-contacts
      pkgs.gnome-connections
      pkgs.gnome-photos
    ];
  };
}
