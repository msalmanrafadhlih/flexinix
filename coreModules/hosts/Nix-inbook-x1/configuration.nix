{ mapFile, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ mapFile ./modules [ "secrets" ] { };
}
