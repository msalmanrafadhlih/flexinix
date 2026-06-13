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
    fileManager = "dolphin";
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
    backupFileExtension = "hm-bak";
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
            # desktop configuration (themes)
            "macos-kdeplasma"

            # cli
            "bat"
            "fastfetch"
            "nix-search"
            "gemini"
            "beets"
            "kitty"
            "cava"
            "nano"
            "xytz"

            # GUI app
            "vesktop"
            "zed-editor"

            "zen-flatpak"
            "zoom-flatpak"
            "motrix-flatpak"
            "blanket-flatpak"
            "nocturne-flatpak"
            "audiotube-flatpak"
          ];
        };
      };
    };
  };
}
