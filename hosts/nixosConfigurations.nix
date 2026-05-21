{ nixos, ... }: {

  # NixOS funcion : hostname { arch; username; extraModules; wsl; darwin; }
  # sudo nixos-rebuild (switch | build-vm) --flake ./#( infinix | wsl | mac ... )

  infinix = nixos "unstable" {
    hostname     = "inbook-x1";
    username     = "tquilla";
    system       = "x86_64-linux";
    extraModules = [ ./Nix-inbook-x1/home.nix ];
  };

  wsl = nixos "stable" {
    hostname = "wsl";
    username = "tquilla";
    system   = "x86_64-linux";
    wsl      = true;
  };
}
