{ inputs, pkgs, ... }:
let
  keyfile = "/srv/share/files/secrets/age/key.txt";
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./secrets.nix
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
    # Gunakan systemd service daripada activation script.
    # Biasanya biarkan default.
    # useSystemdActivation = true;

    # Berapa generasi secret lama yang disimpan.
    # 0 = jangan pernah prune.
    keepGenerations = 1;

    # Logging.
    log = [
      "keyImport"
      "secretChanges"
    ];

    # Environment variable tambahan ketika menjalankan
    # sops-install-secrets.
    # environment = { AWS_PROFILE = "production"; };

    secrets = {
      tquilla_password = {

        name = "tquilla_password"; # Nama file di /run/secrets.
        owner = "tquilla"; # Owner file.
        # key      = "password";              # Key di dalam secrets.yaml.
        # path     = "/run/secrets/password"; # Default: /run/secrets/$name
        # format   = "yaml";                  # Override format bila berbeda dengan default.
        # mode     = "0400";                  # Permission.
        # uid      = 1000;                    # Alternatif owner menggunakan UID.
        # group    = "users";                 # Default mengikuti group owner.
        # gid      = 100;                     # Alternatif group menggunakan GID.
        # sopsFile = ./secrets.yaml ;          # Override file sops.

        restartUnits = [ "nginx.service" ]; # Restart service bila secret berubah.
        # reloadUnits  = [ "nginx.service" ]; # Reload service bila secret berubah.

        # Secret tersedia sebelum user dibuat.
        # Wajib untuk hashedPasswordFile.
        neededForUsers = true;
      };
    };
  };
}
