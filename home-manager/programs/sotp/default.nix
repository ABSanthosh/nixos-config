{
  pkgs ? import <nixpkgs> { },
}:

pkgs.buildGoModule {
  src = ./.;
  pname = "sotp";
  modRoot = ".";
  vendorHash = "sha256-xW/ZX9ApU+TKpZ5BBtA9XOsgXliQ9Y47ZHmy3lghslw=";
  version = "1.0.0";
}
