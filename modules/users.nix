# ./modules/users.nix
{ pkgs, ... }:
let
  # to get password hash = `mkpasswd -m sha-512` // sha-256
  # or use `openssl passwd -6`
  passwd = "$6$4y45xddEerGmBn10$syHxREmf4Ky37ra6ULFwar.I9a/Bts/5k/OxztP3XWhDT.BQ3yEP0z3BUfLXeft4FJERy3RZo.AcaoL6L/H7i0";
  vm-passwd = "123";
  github-email = "141149698+msalmanrafadhlih@users.noreply.github.com";
in
{
  services.getty.autologinUser = "gamemode";
  users.mutableUsers = false;
  users.users = {

    # developer (root)
    tquilla = {
      isNormalUser = true;
      description = "Tquilla - Development";
      shell = pkgs.zsh;
      hashedPassword = passwd;
      extraGroups = [
        "wheel"           # sudo
        "networkmanager"  # Connection(Wifi) Manager
        "docker"          # Container Dev
        "libvirtd" "kvm"  # VM testing
        "adbusers"        # Android Dev
        "video" "audio"   # Dev tools kadang butuh
        "i2c"             # hardware hacking
        "input"           # keylogging keyboard, mouse
      ];

      openssh.authorizedKeys.keys = [
        # `ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub` 
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIApkHQHsqIhDQVzN4Vn+mqU22C9NuZ6v/AI262lf5BH ${github-email}"
      ];
    };

    # Gaming Hardcore
    gamemode = {
      isNormalUser = true;
      description = "Tquilla - Gamemode";
      shell = pkgs.zsh;
      extraGroups = [ "networkmanager" "video" "audio" "input" ];
    };

    # virtMachine
    tquilla-vm = {
      isNormalUser = true;
      description = "Tquilla - virtualM";
      shell = pkgs.zsh;
      password = vm-passwd;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" ];
    	# openssh.authorizedKeys.keyFiles = [
      #   # open `https://github.com/gituhb-username.keys`
    	#   (builtins.fetchurl {
    	#     url = "https://github.com/github-username.keys";
    	#     sha256 = "sha256:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    	#   })
    	# ];
    };

    # container
    service = {
      isNormalUser = false;
      isSystemUser = true;
      description = "Server/Container";
      extraGroups = [
        "docker"
        "podman"
        "acme"
        "postgres"
        "redis"
        "prometheus"
      ];
    };
  };
}
