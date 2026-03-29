{ ... }@args: let

  mkConfigs                = import ./mkConfigs.nix       args;

  overlays                 = import ./overlays            args; 
  packages                 = import ./packages            args; 
  devShells                = import ./devShells           args;
  legacyPackages           = import ./legacyPackages.nix  args; 
  systemConfigs            = import ./systemConfigs.nix   args;
  schemas                  = import ./schemas.nix         args; 

  nixpkgs                  = import ./nixpkgs             args;

in {
  inherit
    mkConfigs
    overlays
    packages
    devShells
    legacyPackages
    systemConfigs
    schemas
    nixpkgs
    ;
}
