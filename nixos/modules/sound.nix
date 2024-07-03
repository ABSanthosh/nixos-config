{ lib, pkgs, ... }: {
  # environment.etc = {
  #   "pipewire/pipewire.conf.d/99-allowed-rates.conf".text = builtins.toJSON {
  #     "context.properties"."default.clock.allowed-rates" = [
  #       44100
  #       48000
  #       88200
  #       96000
  #       176400
  #       192000
  #       358000
  #       384000
  #       716000
  #       768000
  #     ];
  #   };
  #   "pipewire/pipewire-pulse.conf.d/99-resample.conf".text = builtins.toJSON {
  #     "stream.properties"."resample.quality" = 15;
  #   };
  #   "pipewire/client.conf.d/99-resample.conf".text = builtins.toJSON {
  #     "stream.properties"."resample.quality" = 15;
  #   };
  #   "pipewire/client-rt.conf.d/99-resample.conf".text = builtins.toJSON {
  #     "stream.properties"."resample.quality" = 15;
  #   };
  # };

  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
    options snd_hda_intel enable=0,1
  '';

  # services.pipewire = {
  #   enable = false;
  #   alsa.enable = false;
  #   alsa.support32Bit = false;
  #   pulse.enable = true;
  #   wireplumber.enable = true;
  # };

  # # Enable sound with pipewire.
  # sound.enable = true;
  # security.rtkit.enable = true;

  # hardware.pulseaudio = {
  #   enable = true;
  #   extraConfig = "load-module module-combine-sink";
  # };
}
