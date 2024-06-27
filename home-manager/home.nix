{ inputs, lib, config, pkgs, ... }:
let
  username = "santhosh";
  stateVersion = "24.05";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    # Programs
    ./programs/browsers.nix
    ./programs/git.nix
    ./programs/neovim.nix
    # ./programs/tmux.nix
    # ./programs/hyprland.nix


    # Gnome
    # ./desktop-env/gnome/gtk.nix
    # ./desktop-env/gnome/dconf.nix
    # ./desktop-env/gnome/packages.nix
    # ./desktop-env/gnome/extensions.nix

    # Sway
    ./desktop-env/sway.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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
    # enableNixpkgsReleaseCheck = false;

    packages = with pkgs; [
      amberol
      lm_sensors
      mpv
      vlc

      # Development
      go
      git
      vscode
      nodejs
      docker
      mysql80
      openssl
      python311
      typescript

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
      prismlauncher
    ];
  };

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
