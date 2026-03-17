###################################
## ⚡ Nix Daemon & Build Optimization
###################################
{ ... }:
{
  nix.settings = {
    extra-experimental-features = ["nix-command" "flakes"];
    # pastikan sama seperti di nixConfig
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://spicetify-nix.cachix.org"
      "https://racoonfig.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "spicetify-nix.cachix.org-1:jjnwULkvMdu0E5KGBbtgrISEfDdJTGSZ4ATkiFzZn5I="
      "racoonfig.cachix.org-1:JSsJu+Dm6altv3ewOS75Ac9W15huK0t13H2H5pYEWBI="
    ];

    # trusted-public-keys = [  ];
    auto-optimise-store = true;
    warn-dirty = false;
    
    # disable keep-derivations kecuali memang butuh debugging source
    # Enable 'keep-outputs=true' u/ Setiap hasil build derivation disimpan
    # tidak terhapus walau di garbage-collection
    keep-derivations = false;
    # keep-outputs = true;
  };
}
