{
  lib,
  pkgs,
  vars,
  config,
  ...
}:
let
  mod4 = "Mod4";

  swaybar-cmd = pkgs.callPackage ./swaybar/swaybar-cmd.nix { };
  i3blocks-conf = pkgs.callPackage ./i3blocks/i3blocks-conf.nix { };
  misc = import ./misc.nix { inherit pkgs; };
in
{
  imports = [
    ../common/gtk.nix
  ];

  home.packages = with pkgs; [
    udiskie # automount
    ntfs3g # NTFS support
    exfat # exFAT support
    udisks # disk utility
    glib # glibc
    grim # screenshot
    slurp # screen selector
    i3blocks # status bar

    dconf

    libinput # touchpad
    cloak # authenticator
    acpi # battery status
    clipse # clipboard manager
    wl-clipboard # clipboard protocol
    playerctl # media control
    nautilus # file manager
    brightnessctl # brightness control

    # For minecraft
    alsa-oss
    jq

    misc.dbusSwayEnvironment
    misc.configureGtk
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    systemd = {
      enable = true;
      extraCommands = [
        "systemctl --user start sway-session.target"
      ];
      variables = [
        "--all"
      ];
    };

    config = rec {
      modifier = mod4;
      terminal = "kitty";
      defaultWorkspace = "workspace number 1";
      startup = [
        { command = "udiskie"; }
        { command = "clipse --listen"; }
      ];
      output = {
        "eDP-1" = {
          mode = "3840x2160@60Hz";
          scale = "2";
          pos = "1920,2160";
        };
      };
      # Config syntax: https://discourse.nixos.org/t/programs-i3status-rust-enable-has-no-effect-in-home-manager/19728/7
      bars = [
        {
          fonts = {
            names = [
              "JetBrains Mono"
            ];
          };
          # statusCommand = "${swaybar-cmd}/bin/swaybar-cmd";
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ${i3blocks-conf}/bin/i3blocks-conf";
          colors = {
            background = "$crust";
            statusline = "$text";
            focusedStatusline = "$text";
            focusedSeparator = "$base";

            # Workspace colors
            focusedWorkspace = {
              border = "$base";
              background = "$mauve";
              text = "$crust";
            };
            activeWorkspace = {
              border = "$base";
              background = "$surface2";
              text = "$text";
            };
            inactiveWorkspace = {
              border = "$base";
              background = "$base";
              text = "$text";
            };
            urgentWorkspace = {
              border = "$base";
              background = "$red";
              text = "$crust";
            };
          };
        }
      ];

      colors = {
        focused = {
          border = "$base";
          background = "$surface0";
          text = "$text";
          indicator = "$rosewater";
          childBorder = "$lavender";
        };
        focusedInactive = {
          border = "$base";
          background = "$crust";
          text = "$text";
          indicator = "$rosewater";
          childBorder = "$overlay0";
        };
        unfocused = {
          border = "$base";
          background = "$crust";
          text = "$subtext0";
          indicator = "$rosewater";
          childBorder = "$overlay0";
        };
        urgent = {
          border = "$base";
          background = "$base";
          text = "$peach";
          indicator = "$overlay0";
          childBorder = "$peach";
        };
        placeholder = {
          border = "$base";
          background = "$base";
          text = "$text";
          indicator = "$overlay0";
          childBorder = "$overlay0";
        };
        background = "$base";
      };
    };

    extraConfig = ''
      set $mod ${mod4}
      set $alt Mod1

      # Configure display with conservative settings
      output DP-2 resolution 1920x1080@60Hz position 1920,1080 scale 1 adaptive_sync off
      output DP-2 max_render_time off
      output DP-2 allow_tearing no
      output DP-2 render_bit_depth 8

      output DP-1 resolution 1920x1080@60Hz position 1920,1080 scale 1 adaptive_sync off
      output DP-1 max_render_time off
      output DP-1 allow_tearing no
      output DP-1 render_bit_depth 8

      workspace 1 output eDP-1
      workspace 2 output eDP-1
      workspace 3 output eDP-1
      workspace 4 output eDP-1
      workspace 5 output eDP-1
      workspace 6 output DP-1
      workspace 7 output DP-1
      workspace 8 output DP-1
      workspace 9 output DP-1
      workspace 10 output DP-1
      workspace 6 output DP-2
      workspace 7 output DP-2
      workspace 8 output DP-2
      workspace 9 output DP-2
      workspace 10 output DP-2

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

      # Rotate screen
      bindsym $alt+r+Right exec "swaymsg -- output - transform 90"
      bindsym $alt+r+Down exec "swaymsg -- output - transform 0"
      bindsym $alt+r+Left exec "swaymsg -- output - transform 270"

      ###################
      ### Launch Apps ###
      ###################

      bindsym $mod+c exec "kitty"
      bindsym --no-warn $mod+e exec "kitty yazi"
      bindsym --no-warn $mod+shift+e exec "nautilus"
      # bindsym --no-warn $mod+Space exec wofi -show drun
      bindsym --no-warn $mod+v exec "kitty --class clipse -e clipse" 
      bindsym $alt+m exec "cloak view psu | wl-copy"

      # bindsym Mod4+d exec /nix/store/4pr63jvy3s2ch8crazigwxa4pd46cf5i-dmenu-5.3/bin/dmenu_path | /nix/store/4pr63jvy3s2ch8crazigwxa4pd46cf5i-dmenu-5.3/bin/dmenu | /nix/store/r99d2m4swgmrv9jvm4l9di40hvanq1aq-findutils-4.10.0/bin/xargs swaymsg exec --
      bindsym --no-warn $mod+d exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -m 0 | xargs swaymsg exec --

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
        focus
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

      # Quick workspace switching
      bindsym $alt+Tab workspace next_on_output
      bindsym $alt+Shift+Tab workspace prev_on_output

      # Borders
      default_border none 
      default_floating_border normal 0
      default_border pixel 0
      workspace_layout tabbed 
      focus_follows_mouse no

      # Shutdown
      bindsym $alt+F4 exec "systemctl poweroff"
    '';
  };
}
