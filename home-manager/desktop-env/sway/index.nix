{config, pkgs, lib, ...}: 
{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
       {command = "brave";}
       {command = "foot";}
      ];
      output = {
        "eDP-1" = {
	  mode = "3840x2160@60Hz";
	};
      };
    };
  };

  home = {
    packages = with pkgs; [
      foot
      kitty
    ];
  };
}
