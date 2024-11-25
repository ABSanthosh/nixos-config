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
    ./programs/yazi.nix
    ./programs/bash.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/monitors.nix
    ./programs/browsers.nix
    
    ./system/vm.nix

    # Desktop Env
    # ./desktop-env/gnome/default.nix
    # ./desktop-env/sway/default.nix
    ./desktop-env/hyprland/default.nix
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

    packages = with pkgs; [
      mpv
      vlc
      amberol
      starship
      lm_sensors

      # Development
      go
      git
      yazi
      deno
      kitty
      samba
      nodejs
      docker
      mysql80
      openssl
      python311
      typescript
      authenticator
      
      prisma-engines
      unstable.vscode
      python312Packages.prisma
      unstable.cockroachdb-bin

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
