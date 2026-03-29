{ self, ... }: {
  # NixOS funcion : hostname { arch; username; extraModules; wsl; darwin; }
  # sudo nixos-rebuild (switch | build-vm) --flake ./#( infinix | wsl | mac ... )
  infinix = self.mkHost "stable" {
    hostname     = "infinix";
    username     = "tquilla";
    system       = "x86_64-linux";
    extraModules = [ inputs.racooonfig.homeModules.default ];
  };
}
