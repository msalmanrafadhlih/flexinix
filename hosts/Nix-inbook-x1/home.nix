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
}:
let
in
{
  # My Specialisation config use `nixos-rebuild --specialisation (bspwm / hyprland / niri)`
  specialisation.bspwm.configuration = {
    imports = [ inputs.racooonfig.nixosModules.racooonfig ];

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
          inputs
          ;
      };
      users = {
        ${username} = {
          imports = [
            ../../homeModules
            inputs.racooonfig.homeModules.racooonfig
          ];
        };
      };
    };
  };
}
