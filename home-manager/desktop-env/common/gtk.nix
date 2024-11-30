{ pkgs, ... }:
let
  cursor = {
    size = 32;
    pkgs = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
  };

in
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = cursor.name;
      package = cursor.pkgs;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = cursor.name;
      gtk-cursor-theme-size = cursor.size;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = cursor.name;
      gtk-cursor-theme-size = cursor.size;
    };
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = ${cursor.name};
      gtk-cursor-theme-size = ${toString cursor.size};
    '';

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = cursor.name;
      cursor-size = cursor.size;
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };

    "org/gnome/portal/gtk-theme" = {
      color-scheme = "prefer-dark";
    };
  };

  xresources.properties = {
    "Xcursor.size" = cursor.size;
  };

  home = {
    pointerCursor = {
      package = cursor.pkgs;
      name = cursor.name;
      size = cursor.size;
      x11.enable = true;
    };
  };
}
