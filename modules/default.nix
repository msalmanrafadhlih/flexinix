# ./configuration.nix
{ isWSL, isLinux, isDarwin, lib, ... }:
{
  imports = [
    # ./nginx.nix
    ./system-packages.nix
    ./devenv.nix

  ] ++ lib.optionals isDarwin [
    ./darwin.nix

  ] ++ lib.optionals (isLinux && !isWSL) [
    # ./kanata.nix
    ./nixos.nix
    ./virtualisation.nix
    ./locale.nix
    ./shell.nix
    ./settings.nix
    ./users.nix
    ./openssh.nix
    ./nix-ld.nix
    ./fonts.nix
    ./sudo.nix

    # My Specialisation config use `nixos-rebuild --specialisation (bspwm / hyprland / niri)`
    ./specialisations/bspwm.nix
    ./specialisations/hyprland.nix
    ./specialisations/niri.nix
  ];

  environment.pathsToLink = [ 
    "/share/applications" 
    "/share/xdg-desktop-portal" 
  ];
}
