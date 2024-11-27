{ pkgs, config, ... }: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        gcc
        unzip
        cargo
        ripgrep
        gnumake
        tree-sitter
      ];
      plugins = with pkgs.vimPlugins; [ ];
    };
  };
}
