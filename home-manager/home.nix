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
    ./gnome/gtk.nix
    ./gnome/dconf.nix
    ./gnome/extensions.nix
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

      # Screenshot
      # They removed the old, straightforward screenshot tool and replaced it with a new one that is not as good.
      # This is the old one. But it does not copy to clipboard. so we need to install xclip as well.
      # https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/5208#note_1426865
      gnome.gnome-screenshot
      xclip

      # Gnome
      gnome.gnome-boxes
      gnome.gnome-tweaks
      gnome.gnome-terminal

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
