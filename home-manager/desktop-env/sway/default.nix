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

  swaybar-cmd = pkgs.writeTextFile {
    name = "swaybar-cmd";
    destination = "/bin/swaybar-cmd";
    executable = true;
    text = ''
      #!/usr/bin/env bash

      get_mem_info() {
        free | awk '/^Mem:/ {printf "%.0f", $3/1024}'
      }

      prev_mem_info=$(get_mem_info)

      format_mem_info() {
        local curr_mem_info=$(get_mem_info)
        local gib_format=$(echo $curr_mem_info | awk '{printf "%.3f", $1/1024}')

        # if memory delta is negative, then return "▼ {new_mem_info} GiB" in green
        # if memory delta is positive, then return "▲ {new_mem_info} GiB" in red
        # if memory delta is zero, then return "● {new_mem_info} GiB" in orange
        local mem_delta=$(($curr_mem_info - $prev_mem_info))

        # Escape interpolation: https://guergabo.substack.com/p/writing-a-bash-script-the-hard-waywith
        if [ $mem_delta -gt 0 ]; then
          # echo -e "''${RED}▲ ''${gib_format} GiB''${NC}"
          json="{ \"full_text\": \"▲ ''${gib_format} GiB\", \"color\": \"#FF0000\" }"
        elif [ $mem_delta -lt 0 ]; then
          # echo -e "''${GREEN}▼ ''${gib_format} GiB''${NC}"
          json="{ \"full_text\": \"▼ ''${gib_format} GiB\", \"color\": \"#00FF00\" }"
        else
          # echo -e "''${ORANGE}● ''${gib_format} GiB''${NC}"
          json="{ \"full_text\": \"● ''${gib_format} GiB\", \"color\": \"#FFA500\" }"
        fi

       json_array=$(update_holder holder__memory "$json") 
      }

      function update_holder {
        local instance="$1"
        local replacement="$2"
        echo "$json_array" | jq --argjson arg_j "$replacement" "(.[] | (select(.instance==\"$instance\"))) |= \$arg_j"
      }

      function remove_holder {
        local instance="$1"
        echo "$json_array" | jq "del(.[] | (select(.instance==\"$instance\")))"
      }

      function get_brightness {
        local brightness=$(cat /sys/class/backlight/intel_backlight/brightness)
        local max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
        local percentage=$(expr $brightness \* 100 / $max_brightness)
        local json="{ \"full_text\": \"☀ $percentage%\", \"color\": \"#FFFF00\" }"
        json_array=$(update_holder holder__brightness "$json")
      }

      ${pkgs.i3status}/bin/i3status -c ${./swaybar.conf} | (
        read line
        echo "$line"
        read line
        echo "$line"
        read line
        echo "$line"
        read line
        echo "$line"
        while true; do
          read line
          json_array="$(echo $line | sed -e 's/^,//')"
          get_brightness
          format_mem_info
          echo ",$json_array"
          prev_mem_info=$(get_mem_info)
          # sleep 1
        done
      )
    '';
  };
in
{
  # inherit (utils) dbus-sway-environment configure-gtk;

  imports = [
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
    swaylock

    dconf

    cloak #authenticator
    acpi #battery status
    clipse #clipboard manager
    wl-clipboard #clipboard protocol
    playerctl #media control
    nautilus #file manager
    brightnessctl #brightness control

    dbus-sway-environment
    configure-gtk

    # For minecraft
    alsa-oss
    jq

    libinput
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
          scale = "2";
          pos = "1920,2160";
        };
      };
      # Config syntax: https://discourse.nixos.org/t/programs-i3status-rust-enable-has-no-effect-in-home-manager/19728/7
      bars = [
        { statusCommand = "${swaybar-cmd}/bin/swaybar-cmd"; }
      ];
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

      # exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

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
