{ mkConfigs, ... }: {

  # Darwin funcion : stability: { hostname; username; arch: extraModules; }
  # sudo darwin-rebuild (switch | build-vm) --flake .#macbook

  macbook = mkConfigs.darwin "stable" {
    hostname     = "darwin";
    username     = "tquilla";
    system       = "aarch64-darwin";
    extraModules = [];
  };
}
