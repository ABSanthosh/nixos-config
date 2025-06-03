{ ... }:
{
  home.file.".bashrc" = {
    force = true;
    text = ''
      # Ref: https://github.com/mcdonc/.nixconfig/blob/master/videos/pydev/script.rst
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      eval "$(starship init bash)"
      # Enable direnv bash integration
      # eval "$(direnv hook bash)"
    '';
  };
}
