{ config, lib, pkgs, ... }:
let
  cursor-size = 32;
in
{
  gtk = {
    enable = true;
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = "capitaine-cursors";
      gtk-cursor-theme-size = cursor-size;
    };
    gtk2.extraConfig = "gtk-cursor-theme-size=32";
  };
  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     cursor-theme = "capitaine-cursors";
  #     cursor-size = cursor-size;
  #   };
  # };

  xresources.properties = {
    "Xcursor.size" = cursor-size;
  };

  # home.pointerCursor = {
  #   package = pkgs.capitaine-cursors;
  #   name = "capitaine-cursors";
  #   size = cursor-size;
  # };
}
