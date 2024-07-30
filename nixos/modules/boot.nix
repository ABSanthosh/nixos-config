{ config, lib, pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" "exfat" ];
    kernelParams = [  "i915.fastboot=1" "usbcore.autosuspend=-1"];
    # "quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"
    # initrd = {
    #   verbose = false;
    # };
    # consoleLogLevel = 0;
    plymouth = {
      enable = true;
    };
  };
  systemd = {
    watchdog.rebootTime = "0";
    targets.network-online.wantedBy = pkgs.lib.mkForce [ ]; # Normally ["multi-user.target"]
    services = {
      systemd-udev-settle.enable = false;
      NetworkManager-wait-online = {
        enable = false;
        wantedBy = pkgs.lib.mkForce [ ]; # Normally ["network-online.target"] 
      };
    };
  };
}

# {
#   "$schema": "/etc/xdg/swaync/configSchema.json",
#   "positionX": "right",
#   "positionY": "top",
# 	"cssPriority": "user",

#   "control-center-width": 380,
#   "control-center-height": 860, 
#   "control-center-margin-top": 2,
#   "control-center-margin-bottom": 2,
#   "control-center-margin-right": 1,
#   "control-center-margin-left": 0,

#   "notification-window-width": 400,
#   "notification-icon-size": 48,
#   "notification-body-image-height": 160,
#   "notification-body-image-width": 200,

#   "timeout": 4,
#   "timeout-low": 2,
#   "timeout-critical": 6,
  
#   "fit-to-screen": false,
#   "keyboard-shortcuts": true,
#   "image-visibility": "when-available",
#   "transition-time": 200,
#   "hide-on-clear": false,
#   "hide-on-action": false,
#   "script-fail-notify": true,
#   "scripts": {
#     "example-script": {
#       "exec": "echo 'Do something...'",
#       "urgency": "Normal"
#     }
#   },
#   "notification-visibility": {
#     "example-name": {
#       "state": "muted",
#       "urgency": "Low",
#       "app-name": "Spotify"
#     }
#   },
#   "widgets": [
#     "label",
#     "buttons-grid",
#     "mpris",
#     "title",
#     "dnd",
#     "notifications"
#   ],
#   "widget-config": {
#     "title": {
#       "text": "Notifications",
#       "clear-all-button": true,
#       "button-text": " 󰎟 "
#     },
    # "dnd": {
    #   "text": "Do not disturb"
    # },
#     "label": {
#       "max-lines": 1,
#       "text": " "
#     },
#     "mpris": {
#       "image-size": 96,
#       "image-radius": 12
#     },
#     "volume": {
#       "label": "󰕾",
#         "show-per-app": true
#     },
#     "buttons-grid": {
#       "actions": [
#         {
#           "label": " ",
#           "command": "amixer set Master toggle"
#         },
#         {
#           "label": "",
#           "command": "amixer set Capture toggle"
#         },
#         {
#           "label": " ",
#           "command": "nm-connection-editor"
#         },
#         {
#           "label": "󰂯",
#           "command": "blueman-manager"
#         },
#         {
#           "label": "󰏘",
#           "command": "nwg-look"
#         }
        
#       ]
#     }
#   }
# }