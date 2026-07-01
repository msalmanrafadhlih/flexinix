{
  keyfile,
  ...
}:
{
  # Default file yang dipakai seluruh secret.
  defaultSopsFile = ../../../../.lib/secrets/common.yaml;
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

  # Package validasi.
  # package = pkgs.sops-install-secrets;
  # validationPackage = pkgs.sops-install-secrets;


  # Gunakan tmpfs daripada ramfs.
  # Default false demi keamanan swap.
  useTmpfs = false;

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
}
