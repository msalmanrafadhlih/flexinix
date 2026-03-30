{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true; 
  };

  environment.systemPackages = with pkgs; [
    devenv
  ];
}
