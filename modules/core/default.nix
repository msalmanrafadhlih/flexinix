# ./configuration.nix
{ isWSL, isLinux, isDarwin, lib, ... }:
{
  imports = [
    # ./nginx.nix
    ./system-packages.nix
    ./devenv.nix
    ./shell.nix
    ./users.nix
    ./openssh.nix

  ] ++ lib.optionals isDarwin [
    ./darwin.nix

  ] ++ lib.optionals isWSL [

  ] ++ lib.optionals (isLinux && !isWSL) [
    # ./kanata.nix
    ./nixos.nix
    ./virtualisation.nix
    ./locale.nix
    ./settings.nix
    ./thunar.nix
    ./nix-ld.nix
    ./fonts.nix
    ./sudo.nix

    # My Specialisation config use `nixos-rebuild --specialisation (bspwm / hyprland / niri)`
    ../specialisations/bspwm
    ../specialisations/hyprland
    ../specialisations/niri
  ];
}
