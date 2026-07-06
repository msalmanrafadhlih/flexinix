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

  Learning = remoteDrive {
    secrets = {
      client_id = secrets."rclone/drive/learning/client_id".path;
      client_secret = secrets."rclone/drive/learning/client_secret".path;
      token = secrets."rclone/drive/learning/token".path;
    };
    mounts = {
      "Study" = "/srv/share/files/Learning";
    };
  };

  Music = remoteDrive {
    secrets = {
      client_id = secrets."rclone/drive/music/client_id".path;
      client_secret = secrets."rclone/drive/music/client_secret".path;
      token = secrets."rclone/drive/music/token".path;
    };
    mounts = {
      "Musics" = {
        path = "/srv/share/files/Musics";
        extraOptions = {
          # allow-non-empty = true;
          # gid = "100";
        };
      };
    };
  };

  Backup = remoteDrive {
    secrets = {
      client_id = secrets."rclone/drive/backup/client_id".path;
      client_secret = secrets."rclone/drive/backup/client_secret".path;
      token = secrets."rclone/drive/backup/token".path;
    };
    mounts = {
      "" = "/srv/share/files/Backup";
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
