{ inputs, config, lib, pkgs, ...}:
let
  username = "santhosh";
  stateVersion = "24.05";
  homeDirectory = "/home/${username}";
in
{

  imports = [
    # Programs
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/browsers.nix

    # Desktop Environment
    ./desktop-env/sway/default.nix
    # ./desktop-env/gnome/default.nix
  ];

  nixpkgs = {
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

    packages = with pkgs; [   
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

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
