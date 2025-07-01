{
  vars,
  pkgs,
  lib,
  outputs,
  ...
}:
let
  # Custom Packages
  sotp = import ./programs/sotp { inherit pkgs; };
  ingest = import ./programs/ingest { inherit pkgs; };
in
{
  imports = [
    # Programs
    ./programs/git.nix
    # ./programs/tmux.nix
    ./programs/sops.nix
    ./programs/yazi.nix
    ./programs/bash.nix
    ./programs/kitty.nix
    ./programs/neovim.nix
    ./programs/browsers.nix
    ./programs/fastfetch.nix

    # Desktop-env
    ./desktop-env/sway

    # Scripts
    # ./scripts/ingest

  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.patched-phinger-cursors
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  catppuccin = {
    enable = true;
    flavor = vars.catppuccin.flavor;
    mako.enable = false;
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
      age
      git
      mpv
      sops
      yazi
      htop
      sotp # CLI TOTP generator
      ingest # CLI to read git repos and count tokens
      openssl
      starship

      # Code formatters and linters
      nil # Lang server for Nix
      black # Code format Python
      rustfmt # Code format Rust
      shfmt # Code format Shell
      shellcheck # Code lint Shell
      nixfmt-rfc-style # Code format Nix
      nodePackages.prettier # Code format

      # Python
      uv
      python311
      python311Packages.pip
      python311Packages.python-lsp-server

      # fonts
      jetbrains-mono

      # Databases and utils
      mysql80
      # postgresql
      # unstable.cockroachdb-bin I don't think I need this

      # Games
      prismlauncher
      tailscale
    ];
  };
  services = {
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = 49.0;
      longitude = 8.4;
    };
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
