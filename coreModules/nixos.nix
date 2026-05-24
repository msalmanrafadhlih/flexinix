{ system, flakeRoot, ... }:
{
  # services.protonmail-bridge.enable = true;
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  nixpkgs.hostPlatform = system;
  security.rtkit.enable = true;

  system.stateVersion = flakeRoot.stateVersion.linux;
}
