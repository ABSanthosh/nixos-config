{ pkgs, inputs, ... }: {
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    # configDir = ./config;
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.battery
      # fzf
    ];
  };
}
