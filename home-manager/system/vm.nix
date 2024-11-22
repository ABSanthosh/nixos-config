{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    # virtmanager
    virt-manager
    #virtio-win
    #win-spice
  ];


  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
