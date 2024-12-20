{ vars, pkgs, lib, outputs, ... }:
{
  imports = [
    # Programs
    ./programs/git.nix
    # ./programs/tmux.nix
    ./programs/yazi.nix
    ./programs/bash.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    # ./programs/monitors.nix
    ./programs/browsers.nix

    # Desktop-env
    ./desktop-env/sway
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
    username = vars.user.name;
    homeDirectory = lib.mkForce vars.user.home;
    stateVersion = vars.stateVersion;

    packages = with pkgs; [
      mpv
      vlc
      htop
      amberol
      starship
      # lm_sensors

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
      # postgresql
      typescript
      # authenticator move to gnome only
      # passExtensions.pass-otp move to sway only

      prisma-engines
      unstable.vscode
      python312Packages.prisma
      # unstable.cockroachdb-bin I don't think I need this

      black # Code format Python
      shfmt # Code format Shell
      rustfmt # Code format Rust
      shellcheck # Code lint Shell
      nixpkgs-fmt # Code format Nix
      nodePackages.prettier # Code format

      # Python
      python311
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
