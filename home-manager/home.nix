{
  vars,
  pkgs,
  lib,
  outputs,
  ...
}:
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
      # Apps
      vlc
      amberol

      # Programming Languages
      go
      jdk
      samba
      cargo
      rustc
      nodejs
      docker
      typescript
      unstable.deno

      # Editor
      zed-editor
      unstable.vscode

      # CLI tools
      git
      mpv
      yazi
      htop
      kitty
      openssl
      starship

      # Code formatters and linters
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

      # Databases and utils
      mysql80
      # postgresql
      # prisma-engines
      # python312Packages.prisma
      # unstable.cockroachdb-bin I don't think I need this

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
