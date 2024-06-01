{ config, pkgs, lib, ... }:
let
  # wallpaper = "/etc/nixos/assets/Wallpapers/Ventura/Ventura-dark.jpg";
  wallpaper = "/etc/nixos/assets/Wallpapers/cat.png";
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
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-ac-type = "nothing";
      power-button-action = "nothing";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
      disable-while-typing = true;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "brave-browser.desktop"
        "code.desktop"
        "org.gnome.Terminal.desktop"
      ];
    };
    "org/gtk/settings/file-chooser" = {
      # Why lib.hm.gvariant.mkTuple? - https://discourse.nixos.org/t/set-keyboard-repeat-in-gnome-wayland-with-home-manager/25040/2
      window-size = lib.hm.gvariant.mkTuple [ 632 251 ];
      clock-format = "12h";
    };
    "org/gnome/nautilus/preferences" = { click-policy = "single"; };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
    "org/gnome/mutter" = {
      center-new-windows = true;
      edge-tiling = true;
      dynamic-workspaces = true;
    };
    "org/gnome/Console" = {
      font-scale = 1.3;
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "none";
      show-battery-percentage = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "" ];
      minimize = [ "<Super>down" ];
      switch-applications = [ "" ];
      switch-applications-backward = [ "" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
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

# bash command to make all sh files in the scripts directory executable
# find /etc/nixos/scripts -type f -name "*.sh" -exec chmod +x {} \;
