{
  description = "Suckless NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-ld,
      nixpkgs,
      catppuccin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      vars = import ./variables.nix;
      pkgs = nixpkgs.legacyPackages.${vars.user.system};
    in
    {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations.${vars.user.host} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs vars; };
        modules = [
          ./nixos/configuration.nix
          # catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          nix-ld.nixosModules.nix-ld
          {
            programs.nix-ld = {
              enable = true;
              dev.enable = false;
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
                stdenv.cc.cc
                util-linux
                zlib
                zstd
              ];
            };
          }
          {
            home-manager = {
              useUserPackages = true;
              users.${vars.user.name} = {
                imports = [
                  ./home-manager/home.nix
                  catppuccin.homeModules.catppuccin
                ];
              };
              extraSpecialArgs = { inherit inputs outputs vars; };
            };
          }
        ];
      };
    };
}
