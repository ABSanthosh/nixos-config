{
  description = "Zoro Machine Config";

  inputs = {
    # Nix Packages
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
    let 
      system = "x86_64-linux";
      hostname = "zoro";
      username = "santhosh";
      pkgs = nixpkgs.legacyPakages.${system};

      inherit(self) outputs;
    in
    {
      nixosConfigurations = {
        zoro = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
	  modules = [
	    ./nixos/configuration.nix
	    home-manager.nixosModules.home-manager
	    {
	      home-manager = {
	        useUserPackages = true;
		users.santhosh = ./home-manager/home.nix;
	      };
	    }
	  ];
	};
      };	
    };
}
