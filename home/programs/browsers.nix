{ pkgs, config, ... }:

{
  programs = {
    brave = {
      enable = true;
      # commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];
      extensions = [
        
      ];
    };

    firefox = {
      enable = true;
    };
  };
}
