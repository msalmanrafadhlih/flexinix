# Export to main root ../flake.nix
{ flakeRoot, nixpkgs, inputs, ... }:

hostname:
{
  system,
  username,
  extraModules ? [],
  darwin ? false,
  wsl ? false
}:

let
  isWSL = wsl;
  # isDarwin = darwin;
  isLinux = !darwin && !isWSL;

  # The config files for this Machine, OS, and Users(HomeManager)
  machineConfig = ../nixos/${hostname}/configuration.nix;
  userOSConfig = ../modules ;
  userHMConfig =  [ ../modules/home ] ++ extraModules;

  # overlays modules
  overlays = import ./overlays { inherit inputs; };

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  homeManager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system;
  modules = [
    # Apply our overlays. Overlays are keyed by system type so we have
    # to go through and apply our system type. We do this first so
    # the overlays are available globally.
    { nixpkgs.overlays = overlays; }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }

    # Bring in WSL if this is a WSL build
    (if isWSL then inputs.nixos-wsl.nixosModules.wsl else {})

    # Snapd on Linux
    (if isLinux then inputs.nix-snapd.nixosModules.default else {})

    machineConfig
    userOSConfig
    homeManager.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = { inherit system username hostname flakeRoot isWSL; rootInputs = inputs; };
      home-manager.users = {
        ${username} = { imports = userHMConfig; };
      };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        system    = system;
        hostname  = hostname;
        username  = username;
        isWSL     = isWSL;
        inputs    = inputs;
        flakeRoot = flakeRoot;
      };
    }
  ];
}
