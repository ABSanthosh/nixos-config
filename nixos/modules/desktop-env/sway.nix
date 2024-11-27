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
}
