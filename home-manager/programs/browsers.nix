{ pkgs, ... }: {
  home.packages = with pkgs; [
    unstable.firefox
    unstable.chromium
    microsoft-edge-dev
  ];

  programs = {
    brave = {
      package = pkgs.unstable.brave;
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--ozone-platform=wayland" # Add Wayland support
        "--enable-features=WebUIDarkMode" # Enable dark mode
        "--ozone-platform-hint=auto" # Use Wayland if available
      ];
      extensions = [
        # { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
        { id = "aljlkinhomaaahfdojalfmimeidofpih"; } # Hide Youtube shorts
      ];
    };

    firefox = {
      enable = true;
      package = pkgs.unstable.firefox;
      enableGnomeExtensions = false; # Explicitly disable GNOME integration
      profiles.default = {
        settings = {
          "widget.use-xdg-desktop-portal" = true;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };
    };
  };
}
