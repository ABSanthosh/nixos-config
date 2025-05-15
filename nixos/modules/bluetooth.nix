# https://github.com/MatthiasBenaets/nixos-config/blob/master/modules/hardware/bluetooth.nix
{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoEnable = true;
        ControllerMode = "bredr";
        JustWorksRepairing = "always";

        # https://github.com/3rd/config/blob/b9e4c0ea11d724e9d94c413d790b1a2151a694ff/modules/bluetooth.nix
        FastConnectable = true;
        Experimental = true;
        KernelExperimental = true;
      };
      LE = {
        EnableAdvMonInterleaveScan = 1;
      };
    };
  };

  services.blueman.enable = true;
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [
      "network.target"
      "sound.target"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };
}
