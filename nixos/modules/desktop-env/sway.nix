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
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      })
    '';
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
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
  };

  services.gnome.gnome-keyring.enable = true;
  programs.sway = {
    # enable = true;
    wrapperFeatures.gtk = true;
  };

  services.greetd = {
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

  environment.etc."greetd/environments".text = ''
    sway
  '';
  environment.etc."a_rocket_launching_in_the_sky.png".source = /etc/nixos/assets/Wallpapers/Misc/a_rocket_launching_in_the_sky.png;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "dark";
  };
}
