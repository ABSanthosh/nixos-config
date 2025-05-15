# Ref:
# - https://github.com/kovidgoyal/kitty-themes/blob/master/themes/Catppuccin-Mocha.conf
# - https://github.com/Sigmanificient/dotfiles/blob/9440c9af7b0c6a21294b54f26eb5d3dcd98f2e69/home/kitty.nix#L4
{ vars, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 11;
    };

    settings = {
      confirm_os_window_close = -1;
      window_padding_width = 2;
      detectUrls = true;
      background_opacity = 1;
      background_image = "none";
      editor = "nvim";
      hide_window_decorations = "titlebar-only";

      # # Colors
      # foreground = "$text";
      # background = "$base";
      # selection_foreground = "$base";
      # selection_background = "$rosewater";

      # # Cursor colors
      # cursor = "$rosewater";
      # cursor_text_color = "$base";

      # # URL underline color when hovering with mouse
      # url_color = "$rosewater";

      # # Kitty window border colors
      # active_border_color = "$lavender";
      # inactive_border_color = "$overlay0";
      # bell_border_color = "$yellow";

      # # OS Window titlebar colors
      # wayland_titlebar_color = "system";
      # macos_titlebar_color = "system";

      # # Tab bar colors
      # active_tab_foreground = "$crust";
      # active_tab_background = "$mauve";
      # inactive_tab_foreground = "$text";
      # inactive_tab_background = "$mantle";
      # tab_bar_background = "$crust";

      # # Colors for marks (marked text in the terminal)
      # mark1_foreground = "$base";
      # mark1_background = "$lavender";
      # mark2_foreground = "$base";
      # mark2_background = "$mauve";
      # mark3_foreground = "$base";
      # mark3_background = "$sapphire";

      # # The 16 terminal colors
      # # black
      # color0 = "$surface1";
      # color8 = "$surface2";

      # # red
      # color1 = "$red";
      # color9 = "$red";

      # # green
      # color2 = "$green";
      # color10 = "$green";

      # # yellow
      # color3 = "$yellow";
      # color11 = "$yellow";

      # # blue
      # color4 = "$blue";
      # color12 = "$blue";

      # # magenta
      # color5 = "$pink";
      # color13 = "$pink";

      # # cyan
      # color6 = "$teal";
      # color14 = "$teal";

      # # white
      # color7 = "$subtext1";
      # color15 = "$subtext0";
    };

    # extraConfig = ''
    #   include ${pkgs.catppuccin}/${vars.catppuccin.kitty_theme}
    # '';
  };
}
