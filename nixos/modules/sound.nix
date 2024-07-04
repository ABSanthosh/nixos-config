{ lib, pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;
}
