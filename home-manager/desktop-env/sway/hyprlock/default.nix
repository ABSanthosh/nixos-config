{ vars, ... }:
{
  home.file.".config/hypr/hyprlock.conf" = {
    # Overwrite the file
    force = true;
    text = ''
      general {
        disable_loading_bar = true
        hide_cursor = true
        grace = 0
        no_fade_in = true
        no_fade_out = true
        ignore_empty_input = true
      }

      auth {
        pam:enabled = true
      }

      background {
        monitor =
        path = ${vars.wallpaper}
        blur_passes = 3
        blur_size = 8
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }

      image {
        monitor =
        path = ${vars.profile}
        size = 200
        rounding = -1  # -1 for circle
        border_size = 4
        position = 0, 850
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:1000] echo "$(date +'%I')"
        color = rgba(ffffffff)
        font_size = 370
        font_family = Jetbrains Mono Bold
        position = 0, 500
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:1000] echo "$(date +'%M')"
        color = rgba(DDDDDDff)
        font_size = 370
        font_family = Jetbrains Mono Bold
        position = 0, 70
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:86400000] echo "$(date +'%A, %b %d, %Y')"
        color = rgba(ffffffcc)
        font_size = 35
        font_family = Jetbrains Mono Italic
        position = 0, -200
        halign = center
        valign = center
      }

      input-field {
        monitor =
        size = 400, 70
        outline_thickness = 2
        dots_size = 0.2
        dots_spacing = 0.35
        dots_center = true
        outer_color = rgba(ffffff55)
        inner_color = rgba(25252566)
        font_color = rgb(ffffff)
        font_size = 30
        fade_on_empty = false
        # placeholder_text = <span foreground="##ffffff99">Enter Password...</span>
        hide_input = false
        position = 0, -330
        halign = center
        valign = center
      }
    '';
  };
}
