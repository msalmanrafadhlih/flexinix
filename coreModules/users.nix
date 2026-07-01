# ./modules/users.nix
{ pkgs, config, ... }: {
  # services.getty.autologinUser = "gamemode";
  users.mutableUsers = false;

  users.groups.service = { };

  users.users = {
    tquilla = {
      isNormalUser = true;
      description = "Tquilla";
      shell = pkgs.zsh;
      # to get password hash = `mkpasswd -m sha-512` // sha-256
      # or use `openssl passwd -6`
      hashedPasswordFile = config.sops.secrets.tquilla_password.path;
      extraGroups = [
        "users"
        "wheel" # sudo
        "networkmanager" # Connection(Wifi) Manager
        "docker" # Container Dev
        "libvirtd"
        "kvm" # VM testing
        "adbusers" # Android Dev
        "video"
        "audio" # Dev tools kadang butuh
        "i2c" # hardware hacking
        "input" # keylogging keyboard, mouse
      ];

      # `ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub`
      openssh.authorizedKeys.keyFiles = [
        # config.sops.secrets."github/authorized_keys".path # Not worked
        # open `https://github.com/gituhb-username.keys`
        (builtins.fetchurl {
          url = "https://github.com/msalmanrafadhlih.keys";
          sha256 = "sha256-ZaJ76VzOkvSEQA8Tf2dco+3UapOw4yK4nWK1SV52/BM=";
        })
      ];
    };
  };

  sops.secrets."github/authorized_keys" = { };
}
