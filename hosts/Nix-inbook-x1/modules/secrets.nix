{ inputs, pkgs, ... }: let
  keyfile = "/srv/share/files/secrets/age/key.txt";
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment = {
    systemPackages = with pkgs; [
      age
      sops
    ];
    sessionVariables = {
      SOPS_AGE_KEY_FILE = keyfile;
    };
  };

  sops = {
    # Default file yang dipakai seluruh secret.
    defaultSopsFile = ../../../secrets/common.yaml;
    defaultSopsFormat = "yaml"; # yaml, json, binary, dotenv, ini

    # Default key yang dipakai untuk lookup secret.
    # Jika null maka nama secret digunakan.
    # Contoh:
    #
    # defaultSopsKey = "database";
    # secrets.db.key = "password";
    #
    # akan membaca:
    #
    # database:
    #   password: xxxx
    #
    # defaultSopsKey = null;

    # Validasi seluruh file sops saat evaluation.
    validateSopsFiles = true;

    # Berapa generasi secret lama yang disimpan.
    # 0 = jangan pernah prune.
    keepGenerations = 1;

    # Logging.
    log = [
      "keyImport"
      "secretChanges"
    ];

    # Package validasi.
    # package = pkgs.sops-install-secrets;
    # validationPackage = pkgs.sops-install-secrets;

    # Environment variable tambahan ketika menjalankan
    # sops-install-secrets.
    # environment = { AWS_PROFILE = "production"; };

    # Gunakan tmpfs daripada ramfs.
    # Default false demi keamanan swap.
    useTmpfs = false;

    # Gunakan systemd service daripada activation script.
    # Biasanya biarkan default.
    # useSystemdActivation = true;

    age = {
      keyFile = keyfile; # Lokasi private age key.
      generateKey = false; # Generate key otomatis bila belum ada.

      # Plugin age.
      plugins = [
        # pkgs.age-plugin-yubikey
      ];

      # SSH key yang akan diimport menjadi age identity.
      # Default: host key OpenSSH.
      #
      # sshKeyPaths = [
      #   "/etc/ssh/ssh_host_ed25519_key"
      # ];
    };

    gnupg = {
      # Direktori GPG home.
      # Jika memakai age, biasanya tidak perlu.
      # home = "/root/.gnupg";

      # SSH RSA key yang akan diimport menjadi GPG key.
      # sshKeyPaths = [
      #   "/etc/ssh/ssh_host_rsa_key"
      # ];

      # Package GPG.
      # package = pkgs.gnupg;
    };

    secrets = {
      tquilla_password = {

        name     = "tquilla_password";      # Nama file di /run/secrets.
        owner    = "tquilla";               # Owner file.
        # key      = "password";              # Key di dalam secrets.yaml.
        # path     = "/run/secrets/password"; # Default: /run/secrets/$name
        # format   = "yaml";                  # Override format bila berbeda dengan default.
        # mode     = "0400";                  # Permission.
        # uid      = 1000;                    # Alternatif owner menggunakan UID.
        # group    = "users";                 # Default mengikuti group owner.
        # gid      = 100;                     # Alternatif group menggunakan GID.
        # sopsFile = ./secrets.yaml;          # Override file sops.

        restartUnits = [ "nginx.service" ]; # Restart service bila secret berubah.
        # reloadUnits  = [ "nginx.service" ]; # Reload service bila secret berubah.

        # Secret tersedia sebelum user dibuat.
        # Wajib untuk hashedPasswordFile.
        neededForUsers = true;
      };

      github_email = {};
    };

    # ==========================================================
    # Templates
    # ==========================================================
    #
    # Module ini juga mendukung template, misalnya
    # membuat config dari beberapa secret.
    #
    # templates."app.env".content = ''
    #   DATABASE_URL=${config.sops.placeholder.database_url}
    #   API_KEY=${config.sops.placeholder.api_key}
    # '';
    #
    # File akan muncul di:
    #
    #   config.sops.templates."app.env".path
    #
    # dan dapat dipakai oleh service.
  };
}
