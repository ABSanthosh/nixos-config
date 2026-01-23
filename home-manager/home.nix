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

    # Common
    ./desktop-env/common/gtk.nix
    ./desktop-env/common/xdg.nix
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
      loupe
      vivid
      amberol

      # Programming Languages
      go
      jdk
      samba
      cargo
      rustc
      nodejs_24
      docker
      typescript
      unstable.deno

      # Editor
      zed-editor
      vscode
      # kdePackages.kdenlive

      # CLI tools
      age
      git
      mpv
      sops
      yazi
      htop
      tree
      sotp # CLI TOTP generator
      ingest # CLI to read git repos and count tokens
      openssl
      usbmuxd
      dmenu-rs
      starship
      imagemagick
      libqalculate
      libimobiledevice
      perl540Packages.LaTeXML

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
      python313
      python313Packages.black
      python313Packages.python-lsp-server

      # fonts
      jetbrains-mono

      # Databases and utils
      mysql80
      # postgresql
      # unstable.cockroachdb-bin I don't think I need this

      # Games
      prismlauncher
      tailscale

      # Temp
      ifuse
      libplist
      python312Packages.osxphotos
      exiftool
    ];

    file.".npmrc".text = lib.generators.toINIWithGlobalSection { } {
      globalSection = {
        prefix = "${vars.user.home}/.global-npm-packages";
      };
    };
  };
  # services = {
  #   gammastep = {
  #     enable = true;
  #     provider = "manual";
  #     latitude = 49.0;
  #     longitude = 8.4;
  #   };
  # };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
