# ./configuration.nix
{ isWSL, isLinux, isDarwin, lib, ... }:
{
  imports = [
    # ./nginx.nix
    ./system-packages.nix
    ./devenv.nix
    ./shell

  ] ++ lib.optionals isDarwin [
    ./darwin.nix

  ] ++ lib.optionals (isLinux && !isWSL) [
    # ./kanata.nix
    ./nixos.nix
    ./virtualisation.nix
    ./locale.nix
    ./settings.nix
    ./thunar.nix
    ./users.nix
    ./openssh.nix
    ./nix-ld.nix
    ./fonts.nix
    ./sudo.nix

    # My Specialisation config use `nixos-rebuild --specialisation (bspwm / hyprland / niri)`
    ./specialisations/bspwm
    ./specialisations/hyprland
    ./specialisations/niri
  ];

  environment.pathsToLink = [ 
    "/share/applications" 
    "/share/xdg-desktop-portal" 
  ];
}
