{ pkgs, vars, ... }:
let
  mod4 = "Mod4";
in
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = "*";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    systemd = {
      enable = true;
      extraCommands = [
        "systemctl --user stop sway-session.target"
        "systemctl --user start sway-session.target"
      ];
      variables = [ "--all" ];
    };

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
        # "HDMI-A-1" = {
        #   disable = true;
        #   mode = "1920x1080@60Hz";
        # };
      };
    };

    extraConfig = ''   
      set $mod ${mod4}
      set $alt Mod1

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

      bindsym $mod+c exec "kitty"
      bindsym --no-warn $mod+e exec "kitty yazi"
      bindsym --no-warn $mod+shift+e exec "nautilus"
      bindsym --no-warn $mod+Space exec rofi -show drun
      bindsym --no-warn $mod+v exec "kitty --class clipse -e clipse"
      
      bindsym $mod+t layout toggle tabbed split
      bindsym $mod+Shift+t floating disable; focus parent

      for_window [app_id="clipse"] {
        floating enable
        resize set 622 652
        move position center
      }

      # Tap to click
      input "type:touchpad" {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
      }

      # Set wallpaper
      output "*" bg '${vars.wallpaper}' fill

      # Disable HDMI-4
      output HDMI-A-1 disable

      # Quick workspace switching
      bindsym $alt+Tab workspace next_on_output
      bindsym $alt+Shift+Tab workspace prev_on_output

      # Borders
      default_border none 
      default_floating_border normal 0
      default_border pixel 0
      workspace_layout tabbed 
      focus_follows_mouse no
    '';
  };
}
