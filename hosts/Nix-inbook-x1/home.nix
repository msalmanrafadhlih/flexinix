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

    racooonfig = {
      enable = true;
      fileManager = "dolphin";
      displayManager = "sddm";
      windowManager = [ "bspwm" "hyprland" ];
      gamemode = {
        enable = true;
        programs = [ "steam" ];
      };
    };

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

          racooonfig = {
            homeManager = true;
            flatpak = true;
            listConfigurations = [
             "bspwm" "hyprland" 
             "alacritty" 
             "bat" 
             "fastfetch" 
             "zed-editor" 
             "kitty" 
             "vesktop" 
             "gemini"
             "st" 
             "mpd" 
             "nano" 
             "cava"
             "rmpc" 
             "xytz" 
             "zed-editor"

             "spotify-flatpak" 
             "zen-flatpak"
            ];
          };
        };
      };
    };
  };
}
