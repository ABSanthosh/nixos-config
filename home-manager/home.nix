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
      # outputs.overlays.old-revision-overlay
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
      jdk
      jetbrains.idea-community
      yazi
      unstable.deno
      kitty
      samba
      cargo
      rustc
      nodejs
      docker
      mysql80
      openssl
      # postgresql
      zed-editor
      typescript
      # authenticator move to gnome only
      # passExtensions.pass-otp move to sway only

      prisma-engines
      unstable.vscode
      python312Packages.prisma
      # unstable.cockroachdb-bin I don't think I need this

      black # Code format Python
      rustfmt # Code format Rust
      shfmt # Code format Shell
      rustfmt # Code format Rust
      shellcheck # Code lint Shell
      nixfmt-rfc-style # Code format Nix
      nodePackages.prettier # Code format

      # Python
      python311
      python311Packages.pip
      python311Packages.python-lsp-server

      # fonts
      jetbrains-mono

      # Games
      # oldRevision.
      prismlauncher
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
