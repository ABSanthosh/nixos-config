{ pkgs, lib, inputs, ... }:

{
  import = [
    ./rofi
  ];

  home.packages = with pkgs; [
    polkit_gnome
    rofi
    grim
    slurp
    swaybg
    clipse
    pipewire
    udiskie
    nautilus
    wireplumber
    networkmanagerapplet
    xdg-desktop-portal-hyprland
  ];

  home.file.".config/hypr/hyprsunset.conf" = {
    force = true;
    text = ''
      [hyprsunset]
      lat = 40.0
      lon = -75.0
      temp-day = 6500
      temp-night = 3500
      transition = 60
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig =
      let
        modifier = "SUPER";
        wallpaper = "/etc/nixos/assets/Wallpapers/Misc/a_floral_pattern_of_flowers.png";
        keyboardLayout = "us";
        terminal = "kitty";
      in
      lib.concatStrings [
        ''
          #############################
          ### ENVIRONMENT VARIABLES ###
          #############################

          env = NIXOS_OZONE_WL, 1
          env = NIXPKGS_ALLOW_UNFREE, 1
          env = XDG_CURRENT_DESKTOP, Hyprland
          env = XDG_SESSION_TYPE, wayland
          env = XDG_SESSION_DESKTOP, Hyprland
          env = GDK_BACKEND, wayland, x11
          env = CLUTTER_BACKEND, wayland
          env = QT_QPA_PLATFORM=wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = SDL_VIDEODRIVER, x11
          env = MOZ_ENABLE_WAYLAND, 1

          #################
          ### AUTOSTART ###
          #################

          exec-once = killall -q waybar;sleep .5 && waybar
          exec-once = killall -q swaync;sleep .5 && swaync
          exec-once = killall -q swaybg;sleep .5 && swaybg -i ${wallpaper} -m fill -o *
          exec-once = nm-applet --indicator
          exec-once = systemctl --user start hyprpolkitagent
          exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580#editing-the-configuration-file
          exec-once = clipse -listen
          exec-once = udiskie

          #####################
          ### LOOK AND FEEL ###
          #####################

          general {
            gaps_in = 6
            gaps_out = 8
            border_size = 2
            layout = dwindle
            resize_on_border = true

            col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
            col.inactive_border = rgba(595959aa)
          }

          #############
          ### INPUT ###
          #############

          input {
            kb_layout = ${keyboardLayout}
            kb_options = grp:alt_shift_toggle
            kb_options = caps:super
            follow_mouse = 1
            touchpad {
              natural_scroll = true
              disable_while_typing = true
              scroll_factor = 0.8
            }
            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            accel_profile = flat
          }

          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }
          
          misc {
            initial_workspace_tracking = 0
            mouse_move_enables_dpms = true
            key_press_enables_dpms = false
          }

          ####################
          ### WINDOW RULES ###
          ####################

          windowrule = noborder,^(rofi)$
          windowrule = center,^(rofi)$
          windowrule = float, nm-connection-editor|blueman-manager
          windowrule = float, swayimg|vlc|Viewnior|pavucontrol
          windowrule = float, nwg-look|qt5ct|mpv
          windowrule = float, zoom

          windowrulev2 = float, class:(clipse)
          windowrulev2 = size 622 652, class:(clipse)
          windowrulev2 = stayfocused, title:^()$,class:^(steam)$
          windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
          windowrulev2 = opacity 0.9 0.7, class:^(Brave)$
          windowrulev2 = opacity 0.9 0.7, class:^(nautilus)$
          
          animations {
            enabled = yes
            bezier = wind, 0.05, 0.9, 0.1, 1.05
            bezier = winIn, 0.1, 1.1, 0.1, 1.1
            bezier = winOut, 0.3, -0.3, 0, 1
            bezier = liner, 1, 1, 1, 1
            animation = windows, 1, 6, wind, slide
            animation = windowsIn, 1, 6, winIn, slide
            animation = windowsOut, 1, 5, winOut, slide
            animation = windowsMove, 1, 5, wind, slide
            animation = border, 1, 1, liner
            animation = fade, 1, 10, default
            animation = workspaces, 1, 5, wind
          }

          decoration {
            rounding = 10
            drop_shadow = true
            shadow_range = 4
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
            blur {
                enabled = true
                size = 5
                passes = 3
                new_optimizations = on
                ignore_opacity = off
            }
          }

          plugin {
            hyprtrails {
            }
          }
          dwindle {
            pseudotile = true
            preserve_split = true
          }

          ###################
          ### KEYBINDINGS ###
          ###################

          # Change focus across windows using vim motions and arrow keys
          bind = ${modifier}, left, movefocus, l
          bind = ${modifier}, right, movefocus, r
          bind = ${modifier}, up, movefocus, u
          bind = ${modifier}, down, movefocus, d
          bind = ${modifier}, h, movefocus, l
          bind = ${modifier}, l, movefocus, r
          bind = ${modifier}, k, movefocus, u
          bind = ${modifier}, j, movefocus, d

          # Move across workspaces
          bind = ${modifier}, 1, workspace, 1
          bind = ${modifier}, 2, workspace, 2
          bind = ${modifier}, 3, workspace, 3
          bind = ${modifier}, 4, workspace, 4
          bind = ${modifier}, 5, workspace, 5
          bind = ${modifier}, 6, workspace, 6
          bind = ${modifier}, 7, workspace, 7
          bind = ${modifier}, 8, workspace, 8
          bind = ${modifier}, 9, workspace, 9
          bind = ${modifier}, 0, workspace, 10
          bind = ALT, CONTROL, right, workspace, e+1
          bind = ALT, CONTROL, left, workspace, e-1


          bind = ALT, Tab, cyclenext
          bind = ALT, Tab, bringactivetotop

          bind = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          bind = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          bind = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          
          bind = ,F11, exec, playerctl next
          bind = ,F9, exec, playerctl previous
          bind = ,F10, exec, playerctl play-pause
          bind = ,XF86AudioPlay, exec, playerctl play-pause
          bind = ,XF86AudioPause, exec, playerctl play-pause
          bind = ,XF86AudioNext, exec, playerctl next
          bind = ,XF86AudioPrev, exec, playerctl previous

          # Brightness
          bind = ,XF86MonBrightnessDown, exec, brightnessctl set 1%-
          bind = ,XF86MonBrightnessUp, exec, brightnessctl set +1%

          # Launch apps
          bind = SUPER, C, exec, kitty
          bind = SUPER, E, exec, kitty yazi
          bind = SUPER, SHIFT, E, exec, nautilus
          bind = SUPER, V, exec, ${terminal} --class clipse -e clipse
        ''
      ];
  };
}
 