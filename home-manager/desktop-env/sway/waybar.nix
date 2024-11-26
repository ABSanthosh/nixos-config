{ config, ... }:
{
  programs.waybar = {
    enable = true;
    # style = (builtins.readFile ./style.css);
    # settings = (builtins.readFile ./config.jsonc);
  };
}
