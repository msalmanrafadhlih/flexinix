{ inputs, ... }:
let
  lib = inputs.nixos-stable.lib;
in
{
  # --------------------------------------------------------
  # Google Drive
  # --------------------------------------------------------
  remoteDrive =
    {
      trash ? false,
      secrets ? { },
      mounts ? { }, 
      extraOptions ? { },
    }:
    {
      config = {
        type = "drive";
        scope = "drive";
        use_trash = trash;
      };
      inherit secrets;

      mounts = lib.mapAttrs (
        name: value:
        let
          entry =
            if builtins.isString value then
              {
                path = value;
                extraOptions = { };
              }
            else
              value;
        in
        {
          enable = true;
          mountPoint = entry.path;
          autoMount = true;
          logLevel = "INFO";
          options = {
            vfs-cache-mode = "full"; # off - writes - full
            read-only = false;
            fast-list = true;
            no-checksum = true;
            allow-other = true;
            buffer-size = "32M";
            vfs-read-chunk-size = "128M";
            vfs-read-chunk-size-limit = "1G";
            dir-cache-time = "168h";
            poll-interval = "10m";
            vfs-cache-max-age = "1h";
            vfs-cache-max-size = "4G";
            umask = "000"; # 000, 002, 022
          }
          // extraOptions
          // (entry.extraOptions or { });
        }
      ) mounts;
    };

  # --------------------------------------------------------
  # Backblaze B2
  # --------------------------------------------------------
  remoteB2 =
    {
      hardDelete ? false, 
      secrets ? { },
      serve ? { }, 
    }:
    {
      config = {
        type = "b2";
        hard_delete = hardDelete;
      };
      inherit secrets;

      serve = lib.mapAttrs (name: opts: {
        enable = true;
        protocol = opts.protocol or "http";
        autoStart = true;
        logLevel = "NOTICE";
        options = {
          addr = opts.address or "127.0.0.1:8080";
          dir-cache-time = "5000h";
          poll-interval = "10s";
          vfs-cache-mode = "off"; # Matikan cache buat streaming ringan
        }
        // (opts.extraOptions or { });
      }) serve;
    };

  # --------------------------------------------------------
  # NAS lokal (SFTP)
  # --------------------------------------------------------
  remoteNas =
    {
      user ? "",
      host ? "192.168.1.100",
      port ? 22,
      key_file ? "",
      mounts ? { }, 
      extraOptions ? { },
      serve ? { },
    }:
    {
      config = {
        type = "sftp";
        inherit
          host
          user
          port
          key_file
          ;
        md5sum_command = "md5sum";
        sha1sum_command = "sha1sum";
      };

      mounts = lib.mapAttrs (name: path: {
        enable = true;
        mountPoint = path;
        options = {
          vfs-cache-mode = "minimal";
          allow-other = true;
        }
        // extraOptions;
      }) mounts;

      inherit serve;
    };
}
