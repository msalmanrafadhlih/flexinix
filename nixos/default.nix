{ inputs, mkConfigs, ... }: {

  # NixOS funcion : hostname { arch; username; extraModules; wsl; darwin; }
  # sudo nixos-rebuild (switch | build-vm) --flake ./#( infinix | wsl | mac ... )

  infinix = mkConfigs.nixos "stable" {
    hostname     = "inbook-x1";
    username     = "tquilla";
    system       = "x86_64-linux";
    extraModules = [];
  };

  wsl = mkConfigs.nixos "stable" {
    hostname = "wsl";
    system   = "x86_64-linux";
    username = "tquilla";
    wsl      = true;
  };
}
