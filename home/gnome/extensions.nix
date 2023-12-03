{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.freon
    gnomeExtensions.dash-to-panel
    gnomeExtensions.clipboard-history
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "light-style@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        # gnome-extensions list
        "dash-to-panel@jderose9.github.com"
        "freon@UshakovVasilii_Github.yahoo.com"
        "clipboard-history@alexsaveau.dev"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = false;
      animate-appicon-hover-animation-extent = ''{"RIPPLE": 4, "PLANK": 4, "SIMPLE": 1}'';
      appicon-margin = 1;
      appicon-padding = 5;
      available-monitors = [ 0 ];
      dot-color-dominant = true;
      dot-color-override = false;
      dot-position = "BOTTOM";
      dot-style-focused = "DOTS";
      dot-style-unfocused = "DOTS";
      focus-highlight = true;
      focus-highlight-dominant = true;
      hide-overview-on-startup = true;
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = true;
      intellihide-key-toggle-text = "";
      intellihide-key-toggle = [ "" ];
      leftbox-padding = -1;
      leftbox-size = 0;
      panel-anchors = ''{"0":"MIDDLE"}'';
      panel-element-positions = ''{
        "0": [
          {"element":"showAppsButton","visible":false,"position":"stackedTL"},
          {"element":"activitiesButton","visible":false,"position":"stackedTL"},
          {"element":"leftBox","visible":true,"position":"stackedTL"},
          {"element":"taskbar","visible":true,"position":"centerMonitor"},
          {"element":"centerBox","visible":true,"position":"stackedBR"},
          {"element":"rightBox","visible":true,"position":"stackedBR"},
          {"element":"dateMenu","visible":true,"position":"stackedBR"},
          {"element":"systemMenu","visible":true,"position":"stackedBR"},
          {"element":"desktopButton","visible":false,"position":"stackedBR"}
        ]
      }'';
      panel-lengths = ''{"0":100}'';
      panel-sizes = ''{"0":32}'';
      preview-middle-click-close = false;
      primary-monitor = 0;
      progress-show-count = false;
      secondarymenu-contains-showdetails = true;
      show-apps-icon-file = "";
      show-tooltip = true;
      status-icon-padding = -1;
      stockgs-keep-dash = false;
      stockgs-panelbtn-click-only = false;
      trans-panel-opacity = 0.7;
      trans-use-custom-bg = false;
      trans-use-custom-gradient = true;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = true;
      tray-padding = -1;
      window-preview-show-title = false;
      window-preview-title-font-weight = "inherit";
      window-preview-title-position = "TOP";
      trans-gradient-bottom-opacity = 25;
      trans-gradient-top-opacity = 10;
      show-window-previews = false;
    };

    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Super>h" ];
      display-mode = 3;
      strip-text = true;
      window-width-percentage = 15;
    };

    "org/gnome/shell/extensions/freon" = {
      position-in-panel = "left";
      hot-sensors = [
        "__average__"
        "cpu_fan"
        "__max__"
      ];
      show-icon-on-panel = false;
      show-rotationrate-unit = false;
      show-temperature-unit = true;
      use-gpu-aticonfig = true;
      use-gpu-bumblebeenvidia = true;
      use-gpu-nvidia = true;
    };
  };
}
