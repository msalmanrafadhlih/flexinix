# ./default.nix
{ pkgs, ... }: 

let
  # Definisikan paket individual agar bisa dipanggil secara mandiri
  desktopify-lite = pkgs.callPackage ./desktopify-lite.nix {};
  rip             = pkgs.callPackage ./process-manager.nix {};
in
{
  # Ekspos paket individual (for spesifik packages ex. 'nix build .#desktopify-lite')
  inherit
    desktopify-lite
    rip
    ;

  all = pkgs.symlinkJoin {
    name = "my-packages-collection";
    paths = [
      desktopify-lite
      rip
      # add new custom packages (independent)
    ];
  };
}
