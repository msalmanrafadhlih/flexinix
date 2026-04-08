{ flakeRoot, ... }:

{
  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = flakeRoot.outputs.stateVersion;

  # set your time zone
  time.timeZone = flakeRoot.outputs.timezone;

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
