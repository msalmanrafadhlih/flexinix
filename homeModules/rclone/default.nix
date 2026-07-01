{ config, ... }:
let
  home     = config.home.homeDirectory;
  user     = config.home.username;
  path     = ../../.lib/secrets/rclone.yaml;

  sopsFile = name: {
    "rclone/drive/directory1/${name}" = {
      sopsFile = path;
    };
  };
in

{
  programs.rclone = {
    enable = true;

    # Opsional: Tentukan service provisioner rahasia jika menggunakan selain agenix/sops
    # requiresUnit = "sops-nix.service";

    remotes = {

      gdrive = {
        config = {
          type = "drive";
          scope = "drive";
          use_trash = false;
        };

        secrets = {
          client_id     = config.sops.secrets."rclone/drive/directory1/client_id".path;
          client_secret = config.sops.secrets."rclone/drive/directory1/client_secret".path;
          token         = config.sops.secrets."rclone/drive/directory1/token".path;
        };

        mounts = {
          # Format key: "" -> root folder in google drive
          "" = {
            enable = true;
            mountPoint = "/srv/share/files/gdrive";
            autoMount = true;
            logLevel = "INFO";
            options = {
              vfs-cache-mode = "full"; # off - writes - full
              read-only = false;
              fast-list = true;
              no-checksum = true;
              checker = "16";
              transfers = "8";
              # allow-non-empty = true;
              allow-other = true;
              buffer-size = "32M";
              cache-dir = "${home}/.cache/rclone";
              vfs-read-chunk-size = "128M";
              vfs-read-chunk-size-limit = "1G";
              dir-cache-time = "168h";
              poll-interval = "10m";
              vfs-cache-max-age = "1h";
              vfs-cache-max-size = "4G";
              umask = "000"; # 000, 002, 022
              # gid = "100";
            };
          };
        };
      };

      # ---------------------------------------------------------
      # 2. Contoh Remote Backblaze B2 dengan Fitur Serve (HTTP)
      # ---------------------------------------------------------
      # b2_storage = {
      #   config = {
      #     type = "b2";
      #     hard_delete = true;
      #   };

      #   secrets = {
      #     account = "/run/secrets/b2_account_id";
      #     key = "/run/secrets/b2_application_key";
      #   };

      #   serve = {
      #     # Format key: "nama-bucket/path/folder"
      #     "my-public-bucket/media" = {
      #       enable = true;
      #       protocol = "http";
      #       autoStart = true;
      #       logLevel = "NOTICE";
      #       options = {
      #         addr = "127.0.0.1:8080";
      #         dir-cache-time = "5000h";
      #         poll-interval = "10s";
      #         vfs-cache-mode = "off"; # Matikan cache jika hanya untuk streaming ringan
      #       };
      #     };
      #   };
      # };

      # ---------------------------------------------------------
      # 3. Contoh Remote SFTP Lokal (Tanpa Secrets, memakai Key File)
      # ---------------------------------------------------------
      # nas_lokal = {
      #   config = {
      #     type = "sftp";
      #     host = "192.168.1.100";
      #     user = "admin";
      #     port = 22;
      #     key_file = "${config.home.homeDirectory}/.ssh/id_ed25519";
      #     md5sum_command = "md5sum";
      #     sha1sum_command = "sha1sum";
      #   };

      #   # Menggabungkan Mount dan Serve pada remote yang sama
      #   mounts = {
      #     "Data" = {
      #       enable = true;
      #       mountPoint = "${config.home.homeDirectory}/NAS_Data";
      #       options = {
      #         vfs-cache-mode = "minimal";
      #         allow-other = true; # Catatan: Pastikan user_allow_other diset di /etc/fuse.conf
      #       };
      #     };
      #   };

      #   serve = {
      #     "Public" = {
      #       enable = true;
      #       protocol = "webdav";
      #       options = {
      #         addr = "0.0.0.0:8081";
      #         user = "guest";
      #         pass = "guestpassword123";
      #       };
      #     };
      #   };
      # };

    };
  };
  sops.secrets = (sopsFile "client_id")
              // (sopsFile "client_secret")
              // (sopsFile "token");
}
