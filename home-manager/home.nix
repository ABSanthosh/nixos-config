{ inputs, config, lib, pkgs, ...}:
let
  username = "santhosh";
  stateVersion = "24.05";
  homeDirectory = "/home/${username}";
in
{

  imports = [
    ./programs/browsers.nix

    ./programs/git.nix
    ./programs/neovim.nix

    ./desktop-env/sway/default.nix
  ];

  nixpkgs = {
    overlays = [];
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
      vscode
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
