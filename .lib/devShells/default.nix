{ inputs, self,  ... }:
let
  lib = inputs.nixos-stable.lib;
in
lib.genAttrs lib.systems.flakeExposed (
  system:
  let
    pkgs = import inputs.nixos-unstable {
      inherit system;
      config = self.nixpkgs.default;
      overlays = [
        self.overlays.default
        inputs.racooonfig.overlays.default
      ];
    };
  in
  {

    # Default : nix develop github:msalmanrafadhlih/flexinix#default 
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

    # Flutter : nix develop github:msalmanrafadhlih/flexinix#flutter 
    flutter = inputs.devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ./flutter.nix
      ];
    };

  }
)
