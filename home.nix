{ inputs, mkConfigs, ... }: {

  # HomeManager function : stability { hostname; username; system; extraHomeModules; (boolean: nixOnDroid; wsl; darwin;)}
  # home-manager rebuild switch --flake /etc/nixos#hostname@username

  "infinix@tquilla" = mkConfigs.home "unstable" {
    hostname         = "inbook-x1";
    username         = "tquilla";
    system           = "x86_64-linux";
    extraHomeModules = [ inputs.racooonfig.default ];
  };

  "wsl@tquilla" = mkConfigs.home "stable" {
    hostname         = "wsl";
    username         = "tquilla";
    system           = "x86_64-linux";
    extraHomeModules = [];
    wsl              = true;
  };
}
