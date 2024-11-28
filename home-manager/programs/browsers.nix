{ pkgs, ... }: {
  home.packages = with pkgs; [
    unstable.firefox
    unstable.chromium
    microsoft-edge-dev
  ];

  programs = {
    brave = {
      package = pkgs.unstable.brave;
      commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];
      extensions = [
        # { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
        { id = "aljlkinhomaaahfdojalfmimeidofpih"; } # Hide Youtube shorts
      ];
    };
  };
}
