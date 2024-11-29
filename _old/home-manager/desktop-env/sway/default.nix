{ config, pkgs, lib, ... }:
let
  mod4 = "Mod4";

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session
      systemctl --user start pipewire pipewire-media-session
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        # gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita:dark'
      in
      ''`
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        export GTK_THEME=Adwaita:dark
      '';
  }; 
in
{
  imports = [
    ./rofi.nix
    ./waybar.nix
    ../gnome/gtk.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = mod4;
      defaultWorkspace = "workspace number 1";
      terminal = "kitty";
      # bars = [{ command = "swaybar_command waybar"; }];
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
      set $mod ${mod4}


      bindsym Print               exec shotman -c output
      bindsym Print+Shift         exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window

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

      bindsym --no-warn $mod+e exec "kitty yazi"
      bindsym --no-warn $mod+shift+e exec "nautilus"
      bindsym --no-warn $mod+v exec "kitty --class clipse -e clipse"
      # bindsym --no-warn $mod+V exec kitty -e sh -c "swaymsg floating enable, move position center; swaymsg resize set 80ppt 80ppt && clipse"

      bindsym $mod+c exec "kitty"
      bindsym $mod+t layout toggle tabbed split

      bindsym --no-warn $mod+Space exec rofi -show drun

      # Borders
      default_border none 
      # for_window [title="^.*"] title_format " "
      default_floating_border normal 0

      for_window [title="Picture-in-picture"] floating enable, sticky enable, resize set 340 210, move position 1580 849
      for_window [title="Picture in picture"] floating enable, sticky enable, resize set 340 210, move position 1580 849

      for_window [title="Settings"] floating enable, move position center
      for_window [title="Open Files"] floating enable, move position center
      for_window [title="Open Folders"] floating enable, move position center
      for_window [title="Open File"] floating enable, move position center
      for_window [title="Open Folder"] floating enable, move position center
      for_window [title="Save File"] floating enable, move position center
      for_window [title="Copy Files"] floating enable, move position center
      for_window [title="Choose Files"] floating enable, move position center
      for_window [title="File Properties"] floating enable, move position center
      for_window [title="File Operation Progress"] floating enable, resize set 300 200

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
      output "*" bg '/etc/wallpaper.png' fill

      # Disable HDMI-4
      output HDMI-A-4 disable
      
      # set window layout as tabbed by default
      workspace_layout tabbed


      # fx
      blur enable
      blur_passes 10
      blur_radius 10
      blur_noise 0.1
      corner_radius 7
    '';
  };

  home = {
    packages = with pkgs; [
      udiskie #automount
      ntfs3g # NTFS support
      exfat # exFAT support
      udisks # disk utility
      glib
      waybar

      rofi #launcher
      acpi #battery status
      dconf #gsettings
      clipse #clipboard manager
      wl-clipboard #clipboard protocol
      playerctl #media control
      gnome.nautilus #file manager
      brightnessctl #brightness control

      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk

      dbus-sway-environment
    ];
    # pointerCursor = {
    #   name = "capitaine-cursors";
    #   package = pkgs.capitaine-cursors;
    #   size = 32;
    #   x11 = {
    #     enable = true;
    #   };
    # };
  };

  # home.file.".config/gtk-3.0/settings.ini" = {
  #   force = true;
  #   text = ''
  #     [Settings]
  #     gtk-application-prefer-dark-theme=true
  #   '';
  # };
}
