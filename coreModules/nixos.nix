{ system, flakeRoot, ... }:
{

  environment.pathsToLink = [ 
    "/share/applications" 
    "/share/xdg-desktop-portal" 
  ];

  # services.protonmail-bridge.enable = true;
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # External pkgs Manager
  # services.nix-snapd = false;
  nixpkgs.hostPlatform = system;
  security.rtkit.enable = true;


  system.stateVersion = flakeRoot.stateVersion.linux;
}
