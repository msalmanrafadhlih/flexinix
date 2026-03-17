{ inputs, ... }:
{ lib, config, ... }:
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
    
    ./hardware-configuration.nix
  ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    # Opinionated: disable channels from `nix-channel --list`,
    # use flake inputs instead
    channel.enable = false; 

    # Opinionated: make flake registry and nix path match flake inputs
    registry       = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath        = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    settings = {
      experimental-features = "nix-command flakes";  # Enable flakes and new 'nix' command
      flake-registry        = "";                    # Disable Global Registry
      nix-path              = config.nix.nixPath;    # Workaround for https://github.com/NixOS/nix/issues/9574
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
