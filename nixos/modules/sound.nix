{ lib, pkgs, ... }: {
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = false;
    alsa.support32Bit = true;
    wireplumber.enable = true;
    jack.enable = false;
  };
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
}