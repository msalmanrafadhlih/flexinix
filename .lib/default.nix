{ inputs, ... }@args:
let
  schemas = inputs.flake-schemas.schemas;
  nixpkgs = inputs.racooonfig.configs;
  packages = inputs.racooonfig.packages;
  legacyPackages = inputs.racooonfig.legacyPackages;

  mkConfigs = import ./mkConfigs.nix args;
  overlays = import ./overlays args;
in
{
  inherit
    nixpkgs
    mkConfigs
    overlays
    schemas
    legacyPackages
    packages
    ;
}
