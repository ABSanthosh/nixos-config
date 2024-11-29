{ vars, pkgs, ... }:
{

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    
    config = { common = { default = "wlr"; }; };
    wlr.enable = true;
    wlr.settings.screencast = {
      output_name = "DP-2";
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };
  security.polkit = {
    enable = true;
    extraConfig = ''
        polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        var permission = {
          // Existing power management rules
          "org.freedesktop.login1.reboot": YES,
          "org.freedesktop.login1.reboot-multiple-sessions": YES,
          "org.freedesktop.login1.power-off": YES,
          "org.freedesktop.login1.power-off-multiple-sessions": YES,

          // UDisks2
          "org.freedesktop.udisks2.filesystem-mount": YES,
          "org.freedesktop.udisks2.filesystem-mount-system": YES,
          "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
          "org.freedesktop.udisks2.filesystem-unmount-others": YES,
          "org.freedesktop.udisks2.filesystem-take-ownership": YES,
          // UDisks2 encrypted devices
          "org.freedesktop.udisks2.encrypted-unlock": YES,
          "org.freedesktop.udisks2.encrypted-unlock-system": YES,
          // UDisks2 power management
          "org.freedesktop.udisks2.eject-media": YES,
          "org.freedesktop.udisks2.power-off-drive": YES,
        };
        if (subject.isInGroup("users")) {
          return permission[action.id];
        }
      });
    '';
  };

  systemd.user.services = {
    # Handle usb automounting
    udiskie = {
      description = "udiskie mount daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.udiskie}/bin/udiskie --automount --notify --tray";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session.command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd sway
        '';
      };
    };
  };

  # To make sure wayland apps display correctly without blurry fonts
  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      OZONE_PLATFORM_HINT = "auto";
      OZONE_PLATFORM = "wayland";
      GTK_VERSION = "4";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';
}
