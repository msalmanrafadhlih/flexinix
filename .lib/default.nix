{ ... }@args: let

  mkConfigs                = import ./mkConfigs.nix       args;

  overlays                 = import ./overlays            args; 
  packages                 = import ./packages            args; 
  devShells                = import ./devShells           args;
  schemas                  = import ./schemas.nix         args; 
  legacyPackages           = import ./legacyPackages.nix  args; 
  # systemConfig             = import ./systemConfigs       args; 

  nixpkgs                  = import ./nixpkgs             args;

in {
  inherit
    nixpkgs
    mkConfigs
    overlays
    packages
    devShells
    schemas
    legacyPackages
    ;
}
