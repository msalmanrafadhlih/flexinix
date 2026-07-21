{ config, lib, pkgs, ... }:
let
  rcloneConfig = "${config.xdg.configHome}/rclone/rclone.conf";
  rcloneBin = lib.getExe pkgs.rclone;

  # -----------------------------------------------------------------
  # Daftar folder yang mau di-sync (bukan di-mount).
  # "remote"  = "NamaRemote:path/di/cloud" (samain dengan remotes.nix)
  # "local"   = folder tujuan di lokal
  # -----------------------------------------------------------------
  targets = {
    Documents = {
      remote = "Documents:root";
      local = "/srv/share/files/Documents";
    };
    Media = {
      remote = "Media:root";
      local = "/srv/share/files/Media";
    };
  };

  mkPullService = name: t: {
    "rclone-pull-${name}" = {
      Unit = {
        Description = "Pull file baru dari ${t.remote} ke lokal (${name})";
        Requires = [ "rclone-config.service" ];
        After = [ "rclone-config.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg t.local}";
        # copy = one-way, gak pernah hapus apa pun di lokal (bukan hard sync)
        # --update = skip file yang di lokal sudah lebih baru/sama
        ExecStart = ''
          ${rcloneBin} copy --config ${rcloneConfig} --update -v \
            ${lib.escapeShellArg t.remote} ${lib.escapeShellArg t.local}
        '';
      };
    };
  };

  mkPullTimer = name: t: {
    "rclone-pull-${name}" = {
      Unit.Description = "Jadwal harian pull ${name}";
      Timer = {
        OnCalendar = "daily";
        Persistent = true; # kalau laptop mati pas jadwal, jalan begitu nyala lagi
        RandomizedDelaySec = "30m";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };

  mkPushService = name: t: {
    "rclone-push-${name}" = {
      Unit = {
        Description = "Push file baru dari lokal ke ${t.remote} (${name})";
        Requires = [ "rclone-config.service" ];
        After = [ "rclone-config.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${rcloneBin} copy --config ${rcloneConfig} --update -v \
            ${lib.escapeShellArg t.local} ${lib.escapeShellArg t.remote}
        '';
      };
      # sengaja TANPA Install.WantedBy -> gak pernah auto-start, murni manual
    };
  };
in
{
  systemd.user.services = lib.foldl' lib.recursiveUpdate { } (
    (lib.mapAttrsToList mkPullService targets)
    ++ (lib.mapAttrsToList mkPushService targets)
  );

  systemd.user.timers = lib.foldl' lib.recursiveUpdate { } (
    lib.mapAttrsToList mkPullTimer targets
  );

  # Command pendek biar kepakenya kayak "git push"
  home.packages = [
    (pkgs.writeShellScriptBin "rclone-push" ''
      set -euo pipefail
      if [ $# -ne 1 ]; then
        echo "Pakai: rclone-push <nama-target>"
        echo "Target: ${lib.concatStringsSep ", " (lib.attrNames targets)}"
        exit 1
      fi
      exec systemctl --user start --wait "rclone-push-$1.service"
    '')
    (pkgs.writeShellScriptBin "rclone-pull-now" ''
      set -euo pipefail
      if [ $# -ne 1 ]; then
        echo "Pakai: rclone-pull-now <nama-target>"
        echo "Target: ${lib.concatStringsSep ", " (lib.attrNames targets)}"
        exit 1
      fi
      exec systemctl --user start --wait "rclone-pull-$1.service"
    '')
  ];
}
