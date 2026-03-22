# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  desktopify-lite = pkgs.callPackage ./desktopify-lite.nix {};
}
