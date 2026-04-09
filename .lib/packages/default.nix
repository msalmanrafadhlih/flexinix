# ../packages/default.nix
{ pkgs, ... }: 

{
  desktopify-lite = pkgs.callPackage ./desktopify-lite.nix {};
  bloodrage-plymouth = pkgs.callPackage ./bloodrage-plymouth.nix {};
  rip = pkgs.callPackages ./process-manager.nix {};
}
