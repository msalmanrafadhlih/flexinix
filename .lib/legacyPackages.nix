inputs: let
  lib = inputs.nixos-stable.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
in forAllSystems (
  system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [ (import ./overlays inputs).default ];
      config = (import ./nixpkgs inputs).config;
    }
  )
  
