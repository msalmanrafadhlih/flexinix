{ mapAll, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ mapAll ./modules [ "secrets" ] { };
}
