{
  remoteDrive,
  remoteNas,
  remoteB2,
  config,
  ...
}:
let
  home = config.home.homeDirectory;
  user = config.home.username;
  secrets = config.sops.secrets;
in
{

  Documents = remoteDrive {
    secrets = {
      client_id = secrets."rclone/drive/document/client_id".path;
      client_secret = secrets."rclone/drive/document/client_secret".path;
      token = secrets."rclone/drive/document/token".path;
    };
    mounts = { };
  };

  Media = remoteDrive {
    secrets = {
      client_id = secrets."rclone/drive/media/client_id".path;
      client_secret = secrets."rclone/drive/media/client_secret".path;
      token = secrets."rclone/drive/media/token".path;
    };
    mounts = { };
  };

  Backups = remoteDrive {
    secrets = {
      client_id = secrets."rclone/drive/backup/client_id".path;
      client_secret = secrets."rclone/drive/backup/client_secret".path;
      token = secrets."rclone/drive/backup/token".path;
    };
    mounts = {
      "root" = {
        path = "/srv/share/files/Backup";
        extraOptions = {
          # allow-non-empty = true;
          # gid = "100";
        };
      };
    };
  };

  # ---------------------------------------------------------
  # 2. Contoh Remote Backblaze B2 dengan Fitur Serve (HTTP)
  # ---------------------------------------------------------
  # b2_storage = remoteB2 {
  #   hardDelete = true;
  #   secrets = {
  #     account = "/run/secrets/b2_account_id";
  #     key = "/run/secrets/b2_application_key";
  #   };

  #   serve = {
  #     # Format key: "nama-bucket/path/folder"
  #     "my-bucket/media" = {
  #       protocol = "http";
  #       address = "127.0.0.1:8080";
  #       extraOptions = { };
  #     };
  #   };
  # };

  # ---------------------------------------------------------
  # 3. Contoh Remote SFTP Lokal (Tanpa Secrets, memakai Key File)
  # ---------------------------------------------------------
  # nas_lokal = remoteNas {
  #   host = "192.168.1.100";
  #   user = "admin";
  #   port = 22;
  #   key_file = "${home}/.ssh/id_ed25519";
  #   exraOptions = {};

  #   # Menggabungkan Mount dan Serve pada remote yang sama
  #   mounts = { "Data" = "${home}/NAS_Data"; };
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
}
