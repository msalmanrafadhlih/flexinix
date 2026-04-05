{ inputs, mkConfigs, ... }: {

  # HomeManager function : stability { hostname; username; system; extraHomeModules; (boolean: nixOnDroid; wsl; darwin;)}
  # home-manager rebuild switch --flake /etc/nixos#hostname@username

  default = mkConfigs.nixOnDroid "stable" {
    hostname         = "nixos";
    username         = "tquilla";
    system           = "aarch64-linux";
    extraModules     = [];
    extraHomeModules = [ inputs.racooonfig.default ];
  };
}
