{ inputs, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      age
      sops
    ];
  };

  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops = {
    defaultSopsFormat = "yaml"; # json, binary, ini
    defaultSopsFile = ../../../secrets.yaml;
    age = {
      keyFile = "/srv/share/files/secrets/age/key.txt";
      generateKey = false; # auto generate key.txt if file corrupt or missing
      validateSopsFiles = true;
    };

    # secrets.tquilla_password = {
    #   # path = "/srv/share/files/secret";
    #   owner = "tquilla";
    #   neededForUsers = true;
    #   restartUnits = [
    #     "nginx.service"
    #   ];
    # };
  };
}
