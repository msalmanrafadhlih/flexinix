# export from ../flake.nix (system environtment)
{
  inputs,
  username,
  system,
  hostname,
  flakeRoot,
  isLinux,
  isDarwin,
  isWSL,
  isAndroid,
  ...
}: let
in {
  specialisation.bspwm.configuration = {
    imports = [ inputs.racooonfig.nixosModules.bspwm-core ];
   
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit
          system
          username
          hostname
          flakeRoot
          isAndroid
          isWSL
          isLinux
          isDarwin
          ;
        rootInputs = inputs;
        inputs = inputs.racooonfig.inputs;
      };
      users = {
        ${username} = {
          imports = [
            ../../homeModules
            inputs.racooonfig.homeModules.default
          ];
        };
      };
    };
  };
}
