{ pkgs, lib, ... }:
{
  # services.envfs.enable = lib.mkDefault true;

  programs.nix-ld = {
    enable = lib.mkDefault true;
    libraries = with pkgs; [
      acl
      attr
      bzip2
      dbus
      expat
      fontconfig
      freetype
      fuse3
      icu
      libnotify
      libsodium
      libssh
      libunwind
      libusb1
      libuuid
      nspr
      nss

      zlib
      zstd
      glibc
      util-linux
      gcc.cc.lib
      pkgs.libffi
      stdenv.cc.cc
      stdenv.cc.cc.lib
    ];
  };
}
