# ./pkgs/bloodrage-plymouth.nix
{ fetchFromGitHub, callPackage }:

callPackage (fetchFromGitHub {
  owner = "TQ-See";
  repo = "NixPlymouth-Bloodrage";
  rev = "33d8b1262ee0f7ab20ca9e48f5fa79fae45f91e8";
  hash = "sha256-0000000000000000000000000000000000000000000=";
} + "/package.nix") {}
