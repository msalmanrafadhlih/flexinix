{ inputs, ... }@args:
let
  schemas = inputs.flake-schemas.schemas;
  nixpkgs = inputs.racooonfig.configs;
  packages = inputs.racooonfig.packages;
  legacyPackages = inputs.racooonfig.legacyPackages;

  devShells = import ./devShells args;
  mkConfigs = import ./mkConfigs.nix args;
  overlays = import ./overlays args;
  # systemConfig   = import ./systemConfigs      args;
in
{
  inherit
    nixpkgs
    mkConfigs
    overlays
    devShells
    schemas
    legacyPackages
    packages
    ;
}
