{ vars, pkgs, ... }:
{
  security.polkit.enable = true;
  users.users.${vars.user.name}.extraGroups = [ "video" ];
  programs.light.enable = true;

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
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

  environment.etc."greetd/environments".text = ''
    sway
  '';
}
