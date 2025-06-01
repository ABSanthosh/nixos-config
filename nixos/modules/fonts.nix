{ pkgs, config, ... }: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
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
