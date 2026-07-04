{ pkgs, config, ... }:
let
  path = ../.lib/secrets/github.yaml;
  sopsFile = target: mode: {
    "github/${target}" = {
      sopsFile = path;
      mode = mode;
    };
  };
in
{
  sops.secrets = (sopsFile "tquilla/private_key"    "0600")
              // (sopsFile "tquilla/token"          "0400")
              // (sopsFile "tquilla/authorized_key" "0444") 
              // (sopsFile "tquilla/username"       "0444") 
              // (sopsFile "tquilla/emailname"      "0444");

  # sops.templates = cara RESMI inject nilai secret ke isi file config
  # berformat teks. Dirender sops-nix saat ACTIVATION (runtime), bukan saat
  # Nix eval -- placeholder beneran diganti isi asli, bukan literal string
  # "$(cat ...)" seperti sebelumnya. File hasil render ini yg boleh dibaca
  # ulang lewat config.sops.templates.<name>.path.
  sops.templates."git-identity".content = ''
    [user]
        name = ${config.sops.placeholder."github/tquilla/username"}
        email = ${config.sops.placeholder."github/tquilla/emailname"}
    [github]
        user = ${config.sops.placeholder."github/tquilla/username"}
  '';

  sops.templates."allowed_signers".content =
    "git-identity namespaces=\"git\" ${config.sops.placeholder."github/tquilla/authorized_key"}\n";

  programs.git = {
    enable = true;
    signing = {
      # Public key file: langsung pakai path secret yang SUDAH ter-decrypt
      # sops (runtime file asli), TIDAK perlu writeText. writeText itu untuk
      # data non-secret yang memang boleh masuk Nix store (world-readable),
      # bukan untuk konten secret apa pun.
      key = config.sops.secrets."github/tquilla/authorized_key".path;
      signByDefault = true;
      format = "ssh";
    };

    # includes: mekanisme resmi git buat "menyisipkan" file config lain yang
    # isinya baru ada di runtime (hasil sops.templates di atas).
    includes = [
      { path = config.sops.templates."git-identity".path; }
    ];

    settings = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass

      # allowedSignersFile buat verifikasi ssh signature LOKAL saja
      # (`git log --show-signature`). Verifikasi di GitHub sendiri tidak
      # butuh ini -- GitHub sudah tau public key kamu dari Settings > SSH
      # and GPG keys > SSH signing keys.
      gpg.ssh.allowedSignersFile = config.sops.templates."allowed_signers".path;

      credential."https://github.com".helper = [
        "" # reset default, and use helper below
        "${pkgs.writeShellScript "git-credential-github" ''
          if [ "$1" = "get" ]; then
            echo "username=$(cat ${config.sops.secrets."github/tquilla/username".path})"
            echo "password=$(cat ${config.sops.secrets."github/tquilla/token".path})"
          fi
        ''}"
      ];
      push.default = "tracking";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      aliases = {
        cleanup = "!git branch --merged | grep -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
        GRAPH = "log --oneline --decorate --graph --all";
        GIT = "!git add . && git commit -m";
      };
    };
  };

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        addKeysToAgent = "yes"; 
        identityFile = config.sops.secrets."github/tquilla/private_key".path;
        identitiesOnly = true;
        user = "git";
      };

      "192.168.1.* nixos" = {
        addKeysToAgent = "yes";
        StrictHostKeyChecking = "accept-new";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
    };
  };
}
