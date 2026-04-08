inputs: let 
  lib = inputs.nixos-stable.lib;
in lib.genAttrs
  lib.systems.flakeExposed
  (system: let 
    pkgs = import inputs.nixos-unstable {
      inherit system;
      config = (import ../nixpkgs inputs).config;
      overlays = [ (import ../overlays inputs).default ];
    };
  in {
    
    # Defaul
    default = inputs.devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        {
          languages.nix.enable = true;
          packages = with pkgs; [
            devenv
            cargo
          ];
        }
      ];
    };

    # Flutter
    flutter = inputs.devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ./flutter.nix
      ];
    };

  })
