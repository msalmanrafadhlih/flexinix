{ inputs, self, ... }@args:
let

  flakeRoot = self;

  nixpkgs = {
    nixpkgs.overlays = [ (import ./overlays args).default ];
    nixpkgs.config = (import ./nixpkgs args).config;
  };
in
{
  nixos =
    stability:
    {
      hostname,
      username,
      system ? "x86_64-linux",
      extraModules ? [ ],
      wsl ? false,
    }:
    let
      isWSL = wsl;
      isDarwin = false;
      isAndroid = false;
      isLinux = !isWSL;

      selectFlake = stable: unstable: if stability == "stable" then stable else unstable;
      pkgsIn = selectFlake inputs.nixos-stable inputs.nixos-unstable;
      hmModule = selectFlake inputs.home-manager-stable.nixosModules.home-manager inputs.home-manager-unstable.nixosModules.home-manager;
      platform = if wsl then "Wsl" else "Nix";

      sharedConfigs = ../coreModules; # Global Configs for AllSystem.
      userOSConfigs = ../hosts/${platform}-${hostname}/configuration.nix;
      checkPath = if builtins.pathExists userOSConfigs then userOSConfigs else { };

    in
    pkgsIn.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          system
          hostname
          username
          pkgsIn
          flakeRoot
          isWSL
          isDarwin
          isLinux
          isAndroid
          ;
      };
      modules = [
        nixpkgs
        sharedConfigs
        checkPath
        hmModule
      ]
      ++ (
        if wsl then [ inputs.nixos-wsl.nixosModules.wsl ] else [ inputs.nix-snapd.nixosModules.default ]
      )
      ++ extraModules;
    };

  darwin =
    stability:
    {
      hostname,
      username,
      system ? "aarch64-darwin",
      extraModules ? [ ],
    }:
    let
      isWSL = false;
      isDarwin = true;
      isAndroid = false;
      isLinux = false;

      selectFlake = stable: unstable: { inherit stable unstable; }.${stability};
      pkgsIn = selectFlake inputs.darwin-stable inputs.darwin-unstable;
      hmModules = selectFlake inputs.home-manager-stable.darwinModules.home-manager inputs.home-manager-unstable.darwinModules.home-manager;

      sharedConfigs = ../coreModules; # Global Configs for AllSystem.
      userOSConfigs = ../hosts/Drw-${hostname}/configuration.nix;
      checkPath = if builtins.pathExists userOSConfigs then userOSConfigs else { };

    in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          system
          hostname
          username
          pkgsIn
          flakeRoot
          isWSL
          isDarwin
          isLinux
          isAndroid
          ;
      };
      modules = [
        nixpkgs
        sharedConfigs
        checkPath
        hmModules
      ]
      ++ extraModules;
    };

  home =
    stability:
    {
      hostname,
      username,
      system,
      extraHomeModules ? [ ],
      nixOnDroid ? false,
      darwin ? false,
      wsl ? false,
    }:
    let
      isWSL = wsl;
      isDarwin = darwin;
      isAndroid = nixOnDroid;
      isLinux = !isAndroid && !isDarwin && !isWSL;

      selectFlake = stable: unstable: { inherit stable unstable; }.${stability};
      pkgsIn = selectFlake inputs.nixos-stable inputs.nixos-unstable;
      hmManager = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;

      # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles)
      userHMConfig = ../homeModules;

    in
    hmManager.lib.homeManagerConfiguration {
      pkgs = import pkgsIn {
        inherit system;
        overlays = [ (import ./overlays { inherit inputs; }).default ];
        config = (import ./nixpkgs { inherit inputs; }).config;
      };
      extraSpecialArgs = {
        inherit
          system
          hostname
          username
          pkgsIn
          flakeRoot
          isAndroid
          isLinux
          isDarwin
          isWSL
          ;
        rootInputs = inputs;
      };
      modules = [ userHMConfig ] ++ extraHomeModules;
    };

  nixOnDroid =
    stability:
    {
      system ? "aarch64-linux",
      extraModules ? [ ],
      extraHomeModules ? [ ],
    }:
    let
      isWSL = false;
      isDarwin = false;
      isAndroid = true;
      isLinux = false;

      selectFlake = stable: unstable: { inherit stable unstable; }.${stability};
      pkgsIn = selectFlake inputs.nixos-stable inputs.nixos-unstable;
      hmManager = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;

      sharedConfigs = ../coreModules; # Global Configs for AllSystem.
      userHMConfig = [ ../homeModules ] ++ extraHomeModules; # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles)

    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import pkgsIn {
        inherit system;
        overlays = [
          (import ./overlays { inherit inputs; }).default
          inputs.nix-on-droid.overlays.default
        ];
        config = (import ./nixpkgs { inherit inputs; }).config;
      };
      extraSpecialArgs = {
        inherit
          inputs
          system
          pkgsIn
          flakeRoot
          isAndroid
          isLinux
          isDarwin
          isWSL
          ;
      };
      home-manager-path = hmManager.outPath;
      modules = [
        sharedConfigs
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-bak";
            config = {
              imports = userHMConfig;
            };
          };
        }
      ]
      ++ extraModules;
    };

}
