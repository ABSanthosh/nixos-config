{ config, inputs, lib, pkgs, system, ... }:

let

  breezeCursors = (pkgs.stdenvNoCC.mkDerivation rec {
    pname = "breeze-cursors";
    version = "1.0";
    src = pkgs.fetchTarball {
      url = "file:///etc/nixos/assets/theme/Beeze-Dark.tar.gz";
      hash = "sha256-i0N/QB5uzqHapMCDl6h6PWPJ4GOAyB1ds9qlqmZacLY=";
    };
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r Breeze_Dark $out/share/icons/
    '';
  });
in
{
  gtk = {
    enable = true;
    cursorTheme = breezeCursors;
  };
}

# sudo mv /home/santhosh/.gtkrc-2.0 /home/santhosh/.gtkrc-2.0.bak
# sudo mv /home/santhosh/.config/gtk-4.0/settings.ini /home/santhosh/.config/gtk-4.0.bak
# sudo mv /home/santhosh/.config/gtk-3.0/settings.ini /home/santhosh/.config/gtk-3.0.bak