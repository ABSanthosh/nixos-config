{config, pkgs, ...}:

{
  home = {
    packages = with pkgs; [ ags ];
    file = {
      ".config/ags/config.js".source = ./config.js
    };
  };
}