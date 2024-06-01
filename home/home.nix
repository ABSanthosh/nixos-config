{ config, pkgs, ... }:

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

  # Setup home details
  home = {
    username = "santhosh";
    homeDirectory = "/home/santhosh";
    stateVersion = "23.11";
    packages = with pkgs; [
      amberol
      gnome.gnome-tweaks
      lm_sensors
      mpv
      vlc
      htop
      deja-dup

      # Screenshot
      # They removed the old, straightforward screenshot tool and replaced it with a new one that is not as good.
      # This is the old one. But it does not copy to clipboard. so we need to install xclip as well.
      # https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/5208#note_1426865
      gnome.gnome-screenshot
      xclip

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
      gnome.gnome-terminal

      black                   # Code format Python
      shfmt                   # Code format Shell
      rustfmt                 # Code format Rust
      shellcheck              # Code lint Shell
      nixpkgs-fmt             # Code format Nix
      nodePackages.prettier   # Code format

      # Python
      python311Packages.pip
      python311Packages.python-lsp-server

      # fonts
      jetbrains-mono

      # Games
      osu-lazer
      prismlauncher
    ];
  };

  # Program configs
  programs = {
    home-manager.enable = true;
  };
}
