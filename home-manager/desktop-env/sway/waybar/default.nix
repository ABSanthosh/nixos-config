{ ... }:
{ config, ... }: {
  home.file = {
    ".config/waybar/config.jsonc".text = ./config.jsonc;
    ".config/waybar/style.css".text = ./style.css;
  };
}
