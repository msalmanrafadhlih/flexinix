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
  imports = [ inputs.racooonfig.nixosModules.racooonfig ];

  racooonfig = {
    enable = true;
    # fileManager = "thunar";
    displayManager = "sddm";
    desktopManager = [ "plasma" ];
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
            # cli
            "bat"
            "fastfetch"
            "nix-search"
            "gemini"
            "nano"
            "xytz"

            # GUI app
            "vesktop"
            "zed-editor"

            "spotify-flatpak"
            "zen-flatpak"
          ];
        };
      };
    };
  };
}
