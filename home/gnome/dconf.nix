{ config, pkgs, ... }:
let
  wallpaper = "/etc/nixos/assets/Wallpapers/Ventura/Ventura-dark.jpg";
in
{
  dconf.settings = {
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${wallpaper}";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${wallpaper}";
      picture-uri-dark = "file://${wallpaper}";
      picture-options = "zoom";
      color-shading-type = "solid";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "none";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "" ];
      minimize = [ "<Super>down" ];
      switch-applications = [ "" ];
      switch-applications-backward = [ "" ];
      switch-windows = [ "<Alt>Tab" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      auto-raise = false;
      focus-new-windows = "smart";
    };
    "org/gnome/shell/keybindings" = {
      screenshot = [ "Print" ];
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      next = [ "F11" ];
      previous = [ "F9" ];
      play = [ "F10" ];
      control-center = [ "<Super>i" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Shutdown";
      command = "dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Shutdown";
      binding = "<Alt>F4";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "System Monitor";
      command = "gnome-system-monitor";
      binding = "<Shift><Control>Escape";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Terminal";
      command = "kgx";
      binding = "<Super>c";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Screenshot";
      command = "sh /etc/nixos/scripts/screenshot.sh";
      binding = "<Shift><Alt>s";
    };
  };
}
