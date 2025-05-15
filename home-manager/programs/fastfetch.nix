{ pkgs }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      # logo = {
      #   type = "kitty-direct";
      #   source = "~/Downloads/jimi.png";
      #   height = 12;
      #   width = 24;
      # };
      display = {
        separator = " ›  ";
      };
      modules = [
        "break"
        {
          type = "title";
          color = {
            user = "36";
            at = "37";
            host = "36";
          };
        }
        "break"
        {
          type = "os";
          key = "OS  ";
          keyColor = "36";
        }
        {
          type = "kernel";
          key = "KER ";
          keyColor = "36";
        }
        {
          type = "packages";
          format = "{} (pacman)";
          key = "PKG ";
          keyColor = "36";
        }
        {
          type = "shell";
          key = "SH  ";
          keyColor = "36";
        }
        {
          type = "terminal";
          key = "TER ";
          keyColor = "36";
        }
        {
          type = "wm";
          key = "WM  ";
          keyColor = "36";
        }
        "break"
        {
          type = "custom";
          format = "               ";
        }
      ];
    };
  };
}
