{config, pkgs, lib, ...}: 
let 
  mod4 = "Mod4";
in 
{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = mod4;
      defaultWorkspace = "1";
      terminal = "kitty";
      startup = [
        { command = "brave"; }
      ];
      output = {
        "eDP-1" = {
          mode = "3840x2160@60Hz";
        };
      };
    };

    extraConfig = ''
      set $mod ${mod4}

      bindsym Print               exec shotman -c output
      bindsym Print+Shift         exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window

      # Brightness
      bindsym --locked XF86MonBrightnessDown exec brightnessctl set 1%-
      bindsym --locked XF86MonBrightnessUp exec brightnessctl set 1%+

      # Volume
      exec 'pulseaudio --daemonize'
      bindsym XF86AudioRaiseVolume  exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
      bindsym XF86AudioLowerVolume  exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
      bindsym XF86AudioMute         exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

      # Borders
      default_border none 
      # for_window [title="^.*"] title_format " "
      # default_floating_border normal 0

      # Tap to click
      input "type:touchpad" {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
      }

      output "*" bg '/etc/a_rocket_launching_in_the_sky.png' fill
    '';
  };

  home = {
    packages = with pkgs; [
      foot
      kitty

      xfce.xfconf
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      
      acpi #battery status
      brightnessctl
      
      pulseaudio
      pulsemixer #audio manager
    ];
    pointerCursor = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 32;
      x11 = {
        enable = true;
      };
    };
  };
}
