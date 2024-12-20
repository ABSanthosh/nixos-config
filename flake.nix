{
  description = "Suckless NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Programs
    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.astal.follows = "astal";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    stylix.url = "github:danth/stylix/release-24.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stylix, home-manager, ... } @ inputs:
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
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          {
            home-manager = {
              useUserPackages = true;
              users.${vars.user.name} = ./home-manager/home.nix;
              extraSpecialArgs = { inherit inputs outputs vars; };
            };
          }
        ];
      };
    };
}
