{ inputs, nixOnDroid, ... }: {

  # HomeManager function : stability { system; extraHomeModules; (boolean: nixOnDroid; wsl; darwin;)}
  # nix-on-droid switch --flake .

  default = nixOnDroid "stable" {
    system           = "aarch64-linux";
    extraModules     = [ ./And-1980/configuration.nix ];
    extraHomeModules = [];
  };
}
