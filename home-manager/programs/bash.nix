{ config, ... }:
{
  home.file.".bashrc" = {
    force = true;
    text = ''
      eval "$(starship init bash)"
      # Enable direnv bash integration
      # eval "$(direnv hook bash)"
    '';
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;

      # https://direnv.net/man/direnv.toml.1.html#whitelist
      config = {
        whitelist = {
          prefix = [ "/home/santhosh" ];
        };
      };
    };
  };
}
