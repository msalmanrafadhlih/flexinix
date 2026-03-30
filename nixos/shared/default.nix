# ./configuration.nix
{ isWSL, isLinux, lib, ... }:
{
  imports = [
    # LINUX AND WSL
    ./system-packages.nix
    ./devenv.nix
    ./shell.nix
    ./openssh.nix
    ./users.nix
    # ./nginx.nix

  ] ++ lib.optionals isWSL [
    # WSL ONLY

  ] ++ lib.optionals (isLinux && !isWSL) [
    # LINUX ONLY
    ./nixos.nix
    ./virtualisation.nix
    ./locale.nix
    ./settings.nix
    ./thunar.nix
    ./nix-ld.nix
    ./fonts.nix
    ./sudo.nix
    # ./kanata.nix

    # My Specialisation config use `nixos-rebuild --specialisation (bspwm / hyprland / niri)`
    ./specialisations/bspwm
    ./specialisations/hyprland
    ./specialisations/niri
  ];
}
