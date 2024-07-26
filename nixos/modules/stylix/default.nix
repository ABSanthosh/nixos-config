{ pkgs, ... }:
let
  cursor-size = 32;
  wallpaper = /etc/nixos/assets/Wallpapers/Misc/a_lighthouse_with_a_large_cloud_of_pink_clouds.jpg;
  # wallpaper = /etc/nixos/assets/Wallpapers/Misc/a_rocket_launching_in_the_sky.png;
in
{
  stylix = {
    enable = true;
    image = wallpaper;
    polarity = "dark";
    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = cursor-size;
    };

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    base16Scheme = ./base16/oxocarbon-dark.yaml;

    targets = {
      plymouth = {
        enable = false;
        # logoAnimated = true;
      };
    };
  };
}
