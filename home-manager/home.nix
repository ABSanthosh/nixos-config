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
    ./programs/lutris.nix
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
      outputs.overlays.old-packages
      outputs.overlays.patched-phinger-cursors
      outputs.overlays.vscode-custom
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  catppuccin = {
    enable = true;
    flavor = vars.catppuccin.flavor;
    mako.enable = true;
    gemini-cli.enable = false;
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
      samba
      cargo
      rustc
      docker
      nodejs_24
      typescript
      unstable.deno
      javaPackages.compiler.openjdk25

      # Editor
      zed-editor
      vscode-custom
      # kdePackages.kdenlive

      # CLI tools
      age
      git
      mpv
      _7zz
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
      perlPackages.LaTeXML

      # Code formatters and linters
      nil # Lang server for Nix
      black # Code format Python
      rustfmt # Code format Rust
      shfmt # Code format Shell
      shellcheck # Code lint Shell
      nixfmt # Code format Nix
      prettier # Code format

      # Python
      uv
      python313
      python313Packages.black
      python313Packages.python-lsp-server

      # fonts
      jetbrains-mono

      # Databases and utils
      mysql84

      # Games
      prismlauncher
      tailscale

      # Temp
      ifuse
      libplist
      # unstable.python313Packages.osxphotos
      exiftool
    ];

    file.".npmrc".text = lib.generators.toINIWithGlobalSection { } {
      globalSection = {
        prefix = "${vars.user.home}/.global-npm-packages";
      };
    };
  };
  programs = {
    home-manager.enable = true;
  };

  services.mako.enable = true;

  home.activation.createScreenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${vars.user.home}/Pictures/Screenshots"
  '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
