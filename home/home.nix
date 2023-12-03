{ config, pkgs, ... }:

{
  imports = [
    # Programs
    ./programs/browsers.nix
    ./programs/git.nix

    # Gnome
    ./gnome/gtk.nix
    ./gnome/dconf.nix
    ./gnome/extensions.nix
  ];

  # Setup home details
  home = {
    username = "santhosh";
    homeDirectory = "/home/santhosh";
    stateVersion = "23.11";
    packages = with pkgs; [
      firefox
      git
      neovim
      vscode
      librewolf
      amberol
      gnome.gnome-tweaks
      brave
      lm_sensors

      # Development
      nodejs
      python311
      mysql80
      docker
      microsoft-edge-dev
      yarn
      nixpkgs-fmt

      # fonts
      jetbrains-mono
    ];
  };

  # Program configs
  programs = {
    home-manager.enable = true;
  };
}
