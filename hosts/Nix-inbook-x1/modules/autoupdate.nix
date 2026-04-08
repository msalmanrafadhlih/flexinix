# ./modules/autoupdate.nix
{ flakeRoot, ... }:
{
  system.autoUpgrade = {
    enable = true;

    flake = flakeRoot.outhPath;

    flags = [
      "--update-input" "nixpkgs"
      "--commit-lock-file"
    ];

    dates = "weekly";
    operation = "switch";
    fixedRandomDelay = true;
    randomizedDelaySec = "1h";

    allowReboot = false;
  };
}
