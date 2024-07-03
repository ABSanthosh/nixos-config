{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # Screenshot
    # They removed the old, straightforward screenshot tool and replaced it with a new one that is not as good.
    # This is the old one. But it does not copy to clipboard. so we need to install xclip as well.
    # https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/5208#note_1426865
    gnome.gnome-screenshot
    xclip

    # Gnome
    gnome.gnome-boxes
    gnome.gnome-tweaks
    gnome.gnome-terminal
  ];
}
