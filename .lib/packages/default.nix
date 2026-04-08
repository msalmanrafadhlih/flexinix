{ inputs, ... }: let
  lib = inputs.nixos-stable.lib;
  forAllSystems = lib.genAttrs lib.systems.flakeExposed;
in forAllSystems (
  system: let
    pkgs = import inputs.nixos-unstable {
      inherit system;
      config = (import ../nixpkgs inputs).config;
      overlays = [ (import ./overlays.nix inputs).default ];
    };
  in

  # custom Packages
  {
    desktopify-lite = pkgs.callPackage ./desktopify-lite.nix {};
    bloodrage-plymouth = pkgs.callPackage ./bloodrage-plymouth.nix {};
  }
)
