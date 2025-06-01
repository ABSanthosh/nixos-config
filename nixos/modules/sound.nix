{ lib, pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
    jack.enable = false;
    pulseaudio.enable = false;
  };
  security.rtkit.enable = true;
}
