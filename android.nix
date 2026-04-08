{ inputs, mkConfigs, ... }: {

  # HomeManager function : stability { system; extraHomeModules; (boolean: nixOnDroid; wsl; darwin;)}
  # nix-on-droid switch --flake .

  default = mkConfigs.nixOnDroid "stable" {
    system           = "aarch64-linux";
    extraModules     = [ ./android/1980 ];
    extraHomeModules = [];
  };
}
