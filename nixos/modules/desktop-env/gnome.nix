{ config, lib, pkgs, ... }:
{
  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "santhosh";
      };
    };
    xserver = {
      displayManager = {
        gdm = {
          enable = true;
          # wayland = true;
          banner = ''
            Hello, Santhosh!
          '';
          autoLogin.delay = 0;
        };
      };
      # Enable the GNOME Desktop Environment.
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
    };

    # Disable tracker 
    gnome.tracker.enable = false;
    gnome.tracker-miners.enable = false;
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      baobab # disk usage analyzer
      epiphany # web browser
      # gedit # text editor
      simple-scan # document scanner
      yelp # help viewer
      geary # email client
      # seahorse # password manager

      pkgs.gnome-tour
      gnome.gnome-characters
      gnome.gnome-logs
      gnome.gnome-maps
      gnome.gnome-music
      gnome.gnome-weather
      gnome.gnome-contacts
      pkgs.gnome-connections
      pkgs.gnome-photos
    ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
