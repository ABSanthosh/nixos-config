{ pkgs, config, ... }: {
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      allowBitmaps = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono" ];
      };
    };
  };
}
