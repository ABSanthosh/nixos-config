{ inputs, lib, config, pkgs, outputs, ... }:
let
  username = "santhosh";
  stateVersion = "24.05";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    # Programs
    ./programs/git.nix
    # ./programs/tmux.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/browsers.nix


    # Desktop Env
    ./desktop-env/gnome/default.nix
    # ./desktop-env/sway/default.nix
    # ./desktop-env/hyprland/default.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    stateVersion = stateVersion;
    homeDirectory = homeDirectory;
    # TODO: change to true when home-manager is updated to 24.11
    enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      amberol
      lm_sensors
      mpv
      vlc

      # Development
      go
      git
      kitty
      nodejs
      docker
      mysql80
      openssl
      python311
      typescript
      unstable.vscode

      black # Code format Python
      shfmt # Code format Shell
      rustfmt # Code format Rust
      shellcheck # Code lint Shell
      nixpkgs-fmt # Code format Nix
      nodePackages.prettier # Code format

      # Python
      python311Packages.pip
      python311Packages.python-lsp-server

      # fonts
      jetbrains-mono

      # Games
      # prismlauncher
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
