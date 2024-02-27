{ pkgs, config, ... }:

{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = with pkgs; [
        gcc
        unzip
        cargo
        ripgrep
        tree-sitter
        gnumake
      ];
      plugins = with pkgs.vimPlugins; [ ];
    };
  };
}
