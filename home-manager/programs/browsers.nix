{pkgs, config, ... }:

{
  home.packages = with pkgs; [
    firefox
    chromium
   # microsoft-edge-dev
  ];

  programs.brave = {
    enable = true;
  };
}
