{ config, vars, ... }:
{
  # imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${vars.user.home}/.config/sops/age/keys.txt";
    defaultSopsFile = vars.sops.secrets;
  };

  # systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
}
