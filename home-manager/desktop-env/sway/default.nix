{ pkgs, vars, ... }:
{

  home.packages = with pkgs; [
    udiskie #automount
    ntfs3g # NTFS support
    exfat # exFAT support
    udisks # disk utility
    glib
    waybar

    # dconf #gsettings

    kanshi
    rofi #launcher
    acpi #battery status
    clipse #clipboard manager
    wl-clipboard #clipboard protocol
    playerctl #media control
    gnome.nautilus #file manager
    brightnessctl #brightness control
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = mod4;
      defaultWorkspace = "workspace number 1";
      terminal = "kitty";
      startup = [
        { command = "brave"; }
        { command = "code"; }
        { command = "waybar"; always = true; }
        { command = "udiskie"; }
        { command = "clipse --listen"; }
      ];
      output = {
        "eDP-1" = {
          mode = "3840x2160@60Hz";
        };
      };
    };

    extraConfig = ''

      exec sleep 5; systemctl --user start kanshi.service


      # Brightness
      bindsym --locked XF86MonBrightnessDown exec brightnessctl --save set 1%-
      bindsym --locked XF86MonBrightnessUp exec brightnessctl --save set 1%+

      # Volume
      bindsym XF86AudioRaiseVolume  exec 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+'
      bindsym XF86AudioLowerVolume  exec 'wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bindsym XF86AudioMute         exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'

      # Media  
      bindsym XF86AudioPrev exec playerctl previous
      bindsym XF86AudioPlay exec playerctl play-pause
      bindsym XF86AudioNext exec playerctl next

      bindsym F9 exec playerctl previous
      bindsym F10 exec playerctl play-pause
      bindsym F11 exec playerctl next


      ###################
      ### Launch Apps ###
      ###################

      bindsym --no-warn $mod+e exec "kitty yazi"
      bindsym --no-warn $mod+shift+e exec "nautilus"
      bindsym $mod+c exec "kitty"
      bindsym $mod+Shift+c exec "kitty --class=clipse clip

      # Tap to click
      input "type:touchpad" {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
      }

      # Set wallpaper
      output "*" bg '/etc/wallpaper.png' fill
    '';
  };
}
