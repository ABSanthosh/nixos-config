{
  description = "Nixos Config with Flakes";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Stylix
    stylix = {
      url = "github:danth/stylix";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stylix, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      hostname = "zoro";
      username = "santhosh";
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (self) outputs;
    in
    {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        zoro = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                users.santhosh = ./home-manager/home.nix;
                extraSpecialArgs = { inherit inputs outputs; };
              };
            }
          ];
        };
      };

      # homeConfigurations = {
      #   "santhosh@zoro" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = pkgs;
      #     extraSpecialArgs = { inherit inputs outputs; };
      #     modules = [
      #       stylix.homeManagerModules.stylix
      #       ./home-manager/home.nix
      #     ];
      #     sharedModules = [{ stylix.enable = true; }];
      #   };
      # };
    };
}
