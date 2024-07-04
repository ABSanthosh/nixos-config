{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    firefox
    chromium
    # microsoft-edge-dev
  ];

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];
    extensions = [
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
      { id = "chphlpgkkbolifaimnlloiipkdnihall"; } # OneTab
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
      # { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark-reader
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
      { id = "aljlkinhomaaahfdojalfmimeidofpih"; } # Hide Youtube shorts
    ];
  };
}
