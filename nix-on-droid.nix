{ inputs, mkConfigs, ... }: {

  # HomeManager function : stability { system; extraHomeModules; (boolean: nixOnDroid; wsl; darwin;)}
  # nix-on-droid switch --flake .

  default = mkConfigs.nixOnDroid "stable" {
    system           = "aarch64-linux";
    extraModules     = [ ./hosts/And-1980/configuration.nix ];
    extraHomeModules = [];
  };
}
