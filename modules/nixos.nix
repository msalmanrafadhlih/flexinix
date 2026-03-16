{ pkgs,  ... }:

{
  # services.protonmail-bridge.enable = true;
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # External pkgs Manager
  services.nix-snapd = false;
}
