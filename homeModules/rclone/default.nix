{ config, lib, ... }:
let
  path = ../../.lib/secrets/rclone.yaml;
  sopsFile = category: {
    "rclone/drive/${category}" = {
      sopsFile = path;
    };
  };

  # https://claude.ai/chat/2db25176-c50e-4a35-bc39-82ae58a3f24d
  inherit (import ../../.lib/mkRemotes.nix { inherit lib; }) remoteDrive remoteB2 remoteNas;
in

{
  imports = [ ./rclone-sync.nix ];

  sops.secrets =
    (sopsFile "document/client_id")
    // (sopsFile "document/client_secret")
    // (sopsFile "document/token")
    // (sopsFile "media/client_id")
    // (sopsFile "media/client_secret")
    // (sopsFile "media/token")
    // (sopsFile "backup/client_id")
    // (sopsFile "backup/client_secret")
    // (sopsFile "backup/token");

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
}
