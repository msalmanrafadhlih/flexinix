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

  sops.templates."jj-identity".content = ''
    [user]
    name = "${config.sops.placeholder."github/tquilla/username"}"
    email = "${config.sops.placeholder."github/tquilla/emailname"}"
  '';

  # Identitas commit (user.name/email) TIDAK auto-sync dari git config,
  # sekalipun repo colocated -- jj wajib punya [user] sendiri. Reuse dari
  # sops.templates."jj-identity" di git.nix (format TOML, BEDA dari
  # "git-identity" yang formatnya git-ini). conf.d/*.toml di-load PALING
  # akhir oleh jj (override config.toml utama di bawah), jadi aman
  # dipisah dari `programs.jujutsu.settings`.
  home.file."${config.xdg.configHome}/jj/conf.d/10-identity.toml".source =
    config.sops.templates."jj-identity".path;

  programs.jujutsu = {
    enable = true;

    settings = {
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
      # Commit signing (SSH) -- reuse identitas & allowed_signers dari
      # git.nix, JANGAN declare ulang secretnya di sini.
      # ------------------------------------------------------------------
      signing = {
        # Opsi behavior:
        #   "own"   -> auto sign ulang commit YANG KAMU BUAT tiap kali
        #              di-modify (rebase, edit description, dst). [dipilih]
        #   "keep"  -> cuma re-sign kalau commit itu sebelumnya udah signed.
        #   "drop"  -> gak auto-sign; commit yg tadinya signed jadi unsigned
        #              setelah dimodifikasi (biasanya dipasangkan dengan
        #              git.sign-on-push = true di bawah).
        #   "force" -> sign SEMUA commit setelah dimodifikasi, sekalipun
        #              bukan authored oleh kamu. Hati-hati pakai ini.
        behavior = "own";
        backend = "ssh";

        # Sama seperti programs.git.signing.key di git.nix: path ke private
        # key, dipakai lewat ssh-agent buat generate signature. Test dulu
        # pas commit pertama; kalau ssh-keygen komplain butuh public key,
        # ganti ke path .pub-nya.
        key = config.sops.secrets."github/tquilla/private_key".path;

        backends.ssh = {
          # Reuse langsung dari git.nix -- JANGAN bikin file allowed_signers
          # baru, itu bakal jadi duplikat sumber data yang sama.
          allowed-signers = config.sops.templates."allowed_signers".path;
        };
      };

      git = {
        # Set true KALAU `signing.behavior = "drop"` di atas dan kamu mau
        # baru sign pas `jj git push` aja (berguna kalau signing-nya butuh
        # interaksi manual/lambat). Karena behavior di sini "own", biarkan false.
        sign-on-push = false;
      };

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
