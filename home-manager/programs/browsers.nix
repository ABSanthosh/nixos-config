{ pkgs, ... }: {
  home.packages = with pkgs; [
    # unstable.firefox
    unstable.chromium
    # unstable.microsoft-edge
  ];

  programs = {
    brave = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--ozone-platform=wayland" # Add Wayland support
      ];
      extensions = [
        # { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
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
