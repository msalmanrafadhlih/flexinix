{ ... }:
{
  imports = [
    ./modules/audio.nix
    ./modules/autoupdate.nix
    ./modules/boot.nix
    ./modules/bluetooth.nix
    ./modules/network.nix
    ./modules/hardware.nix
    ./modules/services.nix
    # ./modules/power.nix
    ./modules/touchpad.nix
    ./modules/fileSystems.nix
    
    ./hardware-configuration.nix

    # My Specialisation config use `nixos-rebuild --specialisation (bspwm / hyprland / niri)`
    ../../coreModules/specialisations/bspwm
    ../../coreModules/specialisations/hyprland
    ../../coreModules/specialisations/niri
  ];

}
