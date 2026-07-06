{ config, ... }:
let
  path = ../../.lib/secrets/rclone.yaml;
  sopsFile = category: {
    "rclone/drive/${category}" = {
      sopsFile = path;
    };
  };

  # https://claude.ai/chat/2db25176-c50e-4a35-bc39-82ae58a3f24d
  inherit (import ../../.lib/mkRemotes.nix) remoteDrive remoteB2 remoteNas;
in

{
  programs.rclone = {
    enable = true;

    # Opsional: Tentukan service provisioner rahasia jika menggunakan selain agenix/sops
    # requiresUnit = "sops-nix.service";

    remotes = import ./remotes.nix {
      inherit
        remoteDrive
        remoteB2
        remoteNas
        config
        ;
    };
  };

  sops.secrets =
    (sopsFile "learning/client_id")
    // (sopsFile "learning/client_secret")
    // (sopsFile "learning/token")
    // (sopsFile "music/client_id")
    // (sopsFile "music/client_secret")
    // (sopsFile "music/token");
}
