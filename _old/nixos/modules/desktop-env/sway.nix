{ config, lib, pkgs, ... }:
{
  imports = [
    ../sound.nix
  ];

  boot = {
    kernelParams = [ "psmouse.synaptics_intertouch=0" ];
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
    pipewire.wantedBy = [ "default.target" ];

    polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

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

  programs.sway = {
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      # Ensure DBus is running for notifications
      if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
        eval $(dbus-launch --sh-syntax)
      fi
    '';
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

  environment.etc."greetd/environments".text = ''
    sway
  '';
  environment.etc."wallpaper.png".source = /etc/nixos/assets/Wallpapers/Misc/a_floral_pattern_of_flowers.png;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "Adwaita:dark";
  };
}
