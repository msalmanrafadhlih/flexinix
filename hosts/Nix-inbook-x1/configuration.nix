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
  ];
}
