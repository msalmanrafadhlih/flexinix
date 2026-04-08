{ inputs, mkConfigs, ... }: {

  # NixOS funcion : hostname { arch; username; extraModules; wsl; darwin; }
  # sudo nixos-rebuild (switch | build-vm) --flake ./#( infinix | wsl | mac ... )

  infinix = mkConfigs.nixos "stable" {
    hostname     = "inbook-x1";
    username     = "tquilla";
    system       = "x86_64-linux";
  };

  wsl = mkConfigs.nixos "stable" {
    hostname = "wsl";
    username = "tquilla";
    system   = "x86_64-linux";
    wsl      = true;
  };
}
