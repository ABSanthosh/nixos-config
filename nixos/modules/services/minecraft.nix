{ pkgs, ... }:
{
  services.minecraft-server = {
    enable = false;
    eula = true; # set to true if you agree to Mojang's EULA: https://account.mojang.com/documents/minecraft_eula
    declarative = true;

    package =
      let
        version = "1.21.7";
        url = "https://piston-data.mojang.com/v1/objects/05e4b48fbc01f0385adb74bcff9751d34552486c/server.jar";
        sha256 = "1vn4a0rqglyc37hrx6b8gbwym3im854ifwll2wkc6741bpvvhmdr";
      in
      (pkgs.minecraft-server.overrideAttrs (old: rec {
        name = "minecraft-server-${version}";
        inherit version;

        src = pkgs.fetchurl {
          inherit url sha256;
        };
      }));

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "Bor World";
      max-players = 2;
      level-seed = "borio";
    };
  };
}
