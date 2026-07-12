{
  config,
  pkgs,
  ...
}:

{
  # fsmonitor.backend = "watchman" butuh binary watchman di PATH.
  home.packages = with pkgs; [
    watchman
  ];

  programs.jujutsu = {
    enable = true;

    # ediff (emacs merge tool) di-skip karena kamu gak pakai emacs.
    # ediff = false; # <- default-nya udah ngikut config.programs.emacs.enable

    settings = {
      # ------------------------------------------------------------------
      # Identitas commit
      # ------------------------------------------------------------------
      # user = {
      #   name = config.sops.placeholder."github/tquilla/username";
      #   email = config.sops.placeholder."github/tquilla/emailname";
      # };

      # ------------------------------------------------------------------
      # UI umum
      # ------------------------------------------------------------------
      ui = {
        color = "auto";
        default-command = [ "log" ];
        graph.style = "curved";
        log-word-wrap = true;

        # Kamu pilih built-in tool, jadi ini dibiarkan eksplisit ":builtin".
        # - diff-editor  -> dipakai buat `jj split`, `jj squash -i`, dll.
        # - merge-editor -> dipakai buat `jj resolve` (3-way merge conflict).
        #   Kalau merge-editor gak di-set, jj bakal buka file berisi
        #   conflict markers pakai `ui.editor` (default: nano).
        diff-editor = ":builtin";
        merge-editor = ":builtin";

        # Nyalain ini karena signing udah aktif, biar status signature
        # kelihatan di `jj log`/`jj show`.
        show-cryptographic-signatures = true;
      };

      # ------------------------------------------------------------------
      # Commit signing (SSH) — NILAI DI BAWAH INI MASIH DUMMY, WAJIB DIGANTI
      # ------------------------------------------------------------------
      # signing = {
      #   # Opsi behavior:
      #   #   "own"   -> auto sign ulang commit YANG KAMU BUAT tiap kali
      #   #              di-modify (rebase, edit description, dst). [dipilih]
      #   #   "keep"  -> cuma re-sign kalau commit itu sebelumnya udah signed.
      #   #   "drop"  -> gak auto-sign; commit yg tadinya signed jadi unsigned
      #   #              setelah dimodifikasi (biasanya dipasangkan dengan
      #   #              git.sign-on-push = true di bawah).
      #   #   "force" -> sign SEMUA commit stelah dimodifikasi, sekalipun
      #   #              bukan authored oleh kamu. Hati-hati pakai ini.
      #   behavior = "own";
      #   backend = "ssh";

      #   # GANTI dengan PUBLIC KEY SSH yang sama persis dengan yang kamu
      #   # pakai buat Git commit signing (gpg.format = ssh / user.signingKey
      #   # di config Git kamu). Dua cara isi:
      #   #
      #   # 1) Tempel isi file .pub-nya langsung sebagai string:
      #   #      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... user@host";
      #   #
      #   # 2) Atau kasih PATH ke file .pub-nya (lebih gampang buat declarative,
      #   #    apalagi kalau key-nya di-manage lewat sops-nix):
      #   key = config.sops.secrets."github/tquilla/private_key".path;

      #   backends.ssh = {
      #     # File `allowed_signers` dipakai buat VERIFIKASI signature —
      #     # baik punya kamu sendiri maupun punya kolaborator lain — pas
      #     # `ui.show-cryptographic-signatures = true`. Format per baris
      #     # (lihat man ssh-keygen(1), bagian ALLOWED SIGNERS):
      #     #
      #     #   <email> <jenis-key> <public-key>
      #     #
      #     # Contoh isi file:
      #     #   141149698+msalmanrafadhlih@users.noreply.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA...
      #     #
      #     # Kamu bisa generate file ini secara declarative via `home.file`,
      #     # misal:
      #     #   home.file."${config.xdg.configHome}/jj/allowed_signers".text = ''
      #     #     141149698+msalmanrafadhlih@users.noreply.github.com ssh-ed25519 AAAA...
      #     #   '';
      #     allowed-signers = "${config.xdg.configHome}/jj/allowed_signers"; # <-- GANTI/buat filenya
      #   };
      # };

      # git = {
      #   # Set true KALAU `signing.behavior = "drop"` di atas dan kamu mau
      #   # baru sign pas `jj git push` aja (berguna kalau signing-nya butuh
      #   # interaksi manual/lambat). Karena behavior di sini "own", biarkan false.
      #   sign-on-push = false;
      # };

      # ------------------------------------------------------------------
      # Filesystem monitor (biar snapshot working-copy lebih cepat)
      # ------------------------------------------------------------------
      fsmonitor = {
        backend = "watchman";
        watchman.register-snapshot-trigger = true;
      };

      # ------------------------------------------------------------------
      # Snapshot behavior
      # ------------------------------------------------------------------
      snapshot = {
        max-new-file-size = "10MiB"; # default 1MiB, dinaikin dikit
        auto-update-stale = true; # auto-update kalau working copy jadi stale
      };

      # ------------------------------------------------------------------
      # Revset aliases
      # ------------------------------------------------------------------
      revset-aliases = {
        # Default: builtin_immutable_heads() = trunk() | tags() | untracked_remote_bookmarks()
        # Contoh kalau mau nambahin bookmark tertentu jadi immutable juga:
        #   "immutable_heads()" = "builtin_immutable_heads() | release@origin";
        "immutable_heads()" = "builtin_immutable_heads()";
      };

      # ------------------------------------------------------------------
      # Aliases command
      # ------------------------------------------------------------------
      aliases = {
        # `jj l` -> log ringkas commit kamu yang belum masuk ke main
        l = [
          "log"
          "-r"
          "(main..@)::"
        ];
        # `jj ll` -> log penuh (semua default revset)
        ll = [ "log" ];
        # `jj sync` -> fetch dari semua remote sekaligus
        sync = [
          "git"
          "fetch"
          "--all-remotes"
        ];
      };

      # ------------------------------------------------------------------
      # Template aliases (kosmetik log)
      # ------------------------------------------------------------------
      template-aliases = {
        # Prefix commit/change id yang ditampilin cukup 8 karakter unik
        "format_short_id(id)" = "id.shortest(8)";
        # Timestamp relatif ("3 hours ago") daripada ISO 8601 penuh
        "format_timestamp(timestamp)" = "timestamp.ago()";
      };
    };
  };
}
