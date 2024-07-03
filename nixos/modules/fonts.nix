{ pkgs, config, ... }: {

  fonts = {
    packages = with pkgs; [
      # jetbrains-mono
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
