{ inputs, ... }@args: let

  lib = inputs.nixos-stable.lib;
  systems = lib.systems.flakeExposed;
  # Bagian yang menangani outputs.packages
  mkSystemPackages =
    modulePath: lib.genAttrs systems (system: let
      basePkgs = inputs.nixos-unstable.legacyPackages.${system};
      pkgs = basePkgs.extend (import ../overlays { inherit inputs; }).default;
    in 
    import modulePath { inherit pkgs; }
  );

  mkConfigs                = import   ./mkConfigs.nix       args;
  overlays                 = import   ./overlays            args; 
  devShells                = import   ./devShells           args;
  schemas                  = import   ./schemas.nix         args; 
  legacyPackages           = import   ./legacyPackages.nix  args; 
  # systemConfig             = import ./systemConfigs       args; 

  nixpkgs                  = import ./nixpkgs             args;

in {
  inherit
    nixpkgs
    mkConfigs
    overlays
    devShells
    schemas
    legacyPackages
    ;

  packages = mkSystemPackages ./packages ;
}
