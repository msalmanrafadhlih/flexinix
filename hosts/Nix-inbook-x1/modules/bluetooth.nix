# ./modules/bluetooth.nix
{ lib, ... }:

{

  systemd.services.bluetooth.wantedBy = lib.mkForce [ ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;

    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
        enable = "source,sink,media,socket";
      };
    };
  };
  services.blueman.enable = true;
}
