{ config, ... }:
{
  home.file.".bashrc" = {
    force = true;
    text = ''
      eval "$(starship init bash)"
    '';
  };
}
