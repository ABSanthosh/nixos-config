{ config, pkgs, ... }:

{
  imports = [
    # Programs
    ./programs/browsers.nix
    ./programs/git.nix

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
      git
      neovim
      vscode
      amberol
      gnome.gnome-tweaks
      lm_sensors
      mpv
      vlc
      htop

      # Screenshot
      # They removed the old, straightforward screenshot tool and replaced it with a new one that is not as good.
      # This is the old one. But it does not copy to clipboard. so we need to install xclip as well.
      # https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/5208#note_1426865
      gnome.gnome-screenshot
      xclip

      # Development
      nodejs
      python311
      mysql80
      docker
      yarn
      nixpkgs-fmt
      python311Packages.pip
      supabase-cli
      nodePackages.prisma
      typescript
      
      # fonts
      jetbrains-mono

      # Games
      prismlauncher
      
    ];
  };

  # Program configs
  programs = {
    home-manager.enable = true;
  };
}
