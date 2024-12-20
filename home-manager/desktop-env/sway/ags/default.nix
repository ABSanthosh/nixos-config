{ pkgs, inputs, ... }: {
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with inputs.ags.packages.${pkgs.system}; [
    apps
    auth
    bluetooth
    mpris
    network
    notifd
    powerprofiles
    river
    tray
    battery
  ];

  programs.ags = {
    enable = true;
    # configDir = ./config;
    extraPackages = with inputs.ags.packages.${pkgs.system}; [
      apps
      auth
      bluetooth
      mpris
      network
      notifd
      powerprofiles
      river
      tray
      battery
      pkgs.fzf
      inputs.astal.packages.${pkgs.system}.default
    ];
  };
}
