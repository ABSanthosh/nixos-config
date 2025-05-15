{ pkgs }:

let
  # Needed for GTK environment setup
  schema = pkgs.gsettings-desktop-schemas;
  datadir = "${schema}/share/gsettings-schemas/${schema.name}";

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session
      systemctl --user start pipewire pipewire-media-session
    '';
  };

  # gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark'
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      export GTK_THEME=Adwaita:dark
    '';
  };
in
{
  dbusSwayEnvironment = dbus-sway-environment;
  configureGtk = configure-gtk;
}
