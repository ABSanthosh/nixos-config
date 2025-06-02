{
  description = "Suckless NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
          home-manager.nixosModules.home-manager
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
