{ ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"
    '';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
