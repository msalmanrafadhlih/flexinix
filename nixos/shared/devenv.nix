{ isLinux, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

  } // (if isLinux then {
    enableZshIntegration = true; 
    enableBashIntegration = true; 

  } else {});

  environment.systemPackages = with pkgs; [
    devenv
  ];
}
