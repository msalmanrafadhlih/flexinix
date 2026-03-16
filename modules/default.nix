# ./configuration.nix
{ isWSL, system, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
 
in
{
  config._module.args = {
    isDarwin  = isDarwin;
    isLinux   = isLinux;
  };

  imports = [
    # ./nginx.nix
    ./system-packages.nix
    ./devenv.nix

  ] ++ lib.optionals isDarwin [
    ./darwin.nix

  ] ++ lib.optionals (isLinux && !isWSL) [
    ./nixos.nix
    ./virtualisation.nix
    ./locale.nix
    ./shell.nix
    ./fileSystems.nix
    ./settings.nix
    ./hardware.nix
    ./users.nix
    ./openssh.nix
    ./nix-ld.nix
    ./fonts.nix
    ./sudo.nix

    # ./kanata.nix
    ./specialisations/bspwm.nix
  ];

  nixpkgs.hostPlatform = system;
  system.stateVersion = "25.11";
  security.rtkit.enable = true;
}
