# Suckless NixOS setup with Sway

## Flake

A great starting point would be [Misterio77's Nix Starter Config](https://github.com/Misterio77/nix-starter-configs). This repo has the basic setup for a NixOS system organization and a flake.nix file that you can use to start your own configuration.

I have used the minimal configuration from this repo and modified it a bit to make it easier to understand.

We will also use Home Manager to handle application configurations and install home-manager as a nix-os module.

Follow this steps to setup a flake and start your NixOS configuration:

1. Making space for Flakes
   When you first install NixOS, you will have a `/etc/nixos` directory. By default, this directory will have a `configuration.nix` and a `hardware-configuration.nix` file. We will need to move these files to a new directory and create a new `flake.nix` file in the `/etc/nixos` directory.

```
cd /etc/nixos
mkdir nixos
mv configuration.nix hardware-configuration.nix nixos
touch flake.nix
```

The flake is the entry point of your system. You set up where to find the packages you'll be installing, the system configuration, and the home-manager configuration. Most of the file is self explanatory.

It takes some inputs and gives some outputs which can be used in other files.

```nix
# flake.nix
{
  description = "Suckless NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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
```

In this file, you can see that we're importing 4 files:

- `./variables.nix`
- `./overlays`
- `./nixos/configuration.nix`
- `./home-manager/home.nix`

You can read about overlays in details <here>, but for now, just make a new file with this code in the root of your `/etc/nixos` directory:

```nix
# overlay/default.nix
# This file defines overlays
{inputs, ...}: {
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
```

Here, we're just using overlay to expose unstable package list through `pkgs.unstable`. Sometimes, you might need the latest version of a package but the stable channel has only the old one. In this case, you can use `pkgs.unstable.<app>` and install the latest version that is in the unstable channel.

Throughout the config, you might need some variables like user name quite often. Instead of repeating yourself, you can declare it in a place and use it everywhere else. You need an attribute set to import from.

```nix
# variables.nix
{
  user = {
    name = "santhosh";
    home = "/home/santhosh";
    host = "zoro";
    system = "x86_64-linux";
  };
}
```

I'm using home-manager to install all of my apps and configure them each if needed. Make a file `home-manager/home.nix`:

```nix
# home-manager/home.nix

{ vars, pkgs, lib, outputs, ... }:
{
  # imports = [
  #   ./programs/browsers.nix
  # ];

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = vars.user.name;
    homeDirectory = lib.mkForce vars.user.home;
    stateVersion = vars.stateVersion;

    packages = with pkgs; [
      # add apps from nixpkgs.
      # python311
      # unstable.vscode
    ];
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
```

Later, if you want to configure a particular program, you can do it in a separate file and import it in the top of the file.