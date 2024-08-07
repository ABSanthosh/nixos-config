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
    ./ags
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
      ];
      output = {
        "eDP-1" = {
          mode = "3840x2160@60Hz";
        };
      };
    };

    extraConfig = ''
      set $mod ${mod4}

      exec wl-paste -t text --watch clipman store --no-persist

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
      bindsym $mod+c exec "kitty"
      bindsym $mod+t layout toggle tabbed split

      # Control Center
      bindsym --no-warn $mod+a exec ags --toggle-window "cc"

      # Borders
      default_border none 
      # for_window [title="^.*"] title_format " "
      default_floating_border normal 0

      for_window [title="Picture-in-picture"] floating enable, sticky enable, resize set 340 210, move position 1580 849
      for_window [title="Picture in picture"] floating enable, sticky enable, resize set 340 210, move position 1580 849

      for_window [title="Open Files"] floating enable, move position center
      for_window [title="Open Folders"] floating enable, move position center
      for_window [title="Open File"] floating enable, move position center
      for_window [title="Open Folder"] floating enable, move position center
      for_window [title="Settings"] floating enable, move position center
      for_window [title="Save File"] floating enable, move position center
      for_window [title="Copy Files"] floating enable, move position center
      for_window [title="Choose Files"] floating enable, move position center
      for_window [title="File Properties"] floating enable, move position center
      for_window [title="File Operation Progress"] floating enable, resize set 300 200

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

      exec dbus-sway-environment
      # exec configure-gtk
    '';
  };

  home = {
    packages = with pkgs; [
      libnotify
      wl-clipboard

      xfce.xfconf
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin

      acpi #battery status
      brightnessctl
      
      glib
      dconf
      bemenu
      playerctl
      configure-gtk
      dbus-sway-environment
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

  home.file.".config/gtk-3.0/settings.ini" = {
    # Overwrite the file
    force = true;
    text = ''
      [Settings]
      gtk-application-prefer-dark-theme=true
    '';
  };
}
