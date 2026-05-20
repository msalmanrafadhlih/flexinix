{ system, flakeRoot, ... }:
{

  environment.pathsToLink = [ 
    "/share/applications" 
    "/share/xdg-desktop-portal" 
    "/share/thumbnailers"
  ];

  # services.protonmail-bridge.enable = true;
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  nixpkgs.hostPlatform = system;
  security.rtkit.enable = true;

  system.stateVersion = flakeRoot.stateVersion.linux;
}
