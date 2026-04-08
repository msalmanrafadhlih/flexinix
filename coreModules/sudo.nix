# ./modules/sudo.nix
{ ... }:

{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;

    extraRules = [
      {
        ## Main User
        ####################
        users = [ "tquilla" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" "SETENV" ];
          }
          {
            command = "/run/current-system/sw/bin/systemctl";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
