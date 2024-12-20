{ pkgs, vars, lib, ... }:
let
  mod4 = "Mod4";

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    # Needed for screen sharing 
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
    ../common/gtk.nix
  ];

  home.packages = with pkgs; [
    udiskie #automount
    ntfs3g # NTFS support
    exfat # exFAT support
    udisks # disk utility
    glib
    grim
    sass
    slurp
    waybar

    dconf

    cloak #authenticator
    acpi #battery status
    clipse #clipboard manager
    wl-clipboard #clipboard protocol
    playerctl #media control
    gnome.nautilus #file manager
    brightnessctl #brightness control

    dbus-sway-environment
    configure-gtk

    # For minecraft
    alsa-oss
  ];

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
      variables = [
        "--all"
      ];
    };

    config = rec {
      modifier = mod4;
      defaultWorkspace = "workspace number 1";
      terminal = "kitty";
      startup = [
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
      set $alt Mod1

      # capture all screens to clipboard    
      bindsym Print exec grim - | wl-copy    
          
      # capture the specified screen area to clipboard    
      bindsym Shift+Alt+s exec grim -g "$(slurp)" - | wl-copy   

      # Save specific screen area to folder /home/username/Pictures/Screenshots
      bindsym $mod+Shift+s exec grim -g "$(slurp)" /home/${vars.user.name}/Pictures/Screenshots/$(date +%Y-%m-%d-%H-%M-%S).png

      exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

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
      bindsym --no-warn $mod+a exec swaync-client -t -sw
      bindsym --no-warn $mod+e exec "kitty yazi"
      bindsym --no-warn $mod+shift+e exec "nautilus"
      # bindsym --no-warn $mod+Space exec wofi -show drun
      bindsym --no-warn $mod+v exec "kitty --class clipse -e clipse"
      bindsym $alt+m exec "cloak view psu | wl-copy"
      
      bindsym $mod+t layout toggle tabbed split
      bindsym $mod+Shift+t floating disable; focus parent
      bindsym $mod+Shift+f floating toggle

      for_window [title="Picture-in-picture"] floating enable, sticky enable, resize set 340 210, move position 1580 849
      for_window [title="Picture in picture"] floating enable, sticky enable, resize set 340 210, move position 1580 849
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
      input type:keyboard {
        repeat_delay 300
        repeat_rate 30
      }

      # Set wallpaper
      output "*" bg '${vars.wallpaper}' fill

      # # Disable HDMI-4
      # output HDMI-A-1 disable

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
