# ./modules/autoupdate.nix
{ flakePath, ... }:
{
  system.autoUpgrade = {
    enable = true;

    flake = flakePath;

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
