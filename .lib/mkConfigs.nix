{ inputs, self, ... }@args:

hostname:
stability:
{
  system,
  username,
  extraModules ? [ ],
  extraHomeModules ? [ ], 
  nixOnDroid ? false,
  darwin ? false,
  home ? false,
  wsl ? false
}:

let
  isWSL = wsl;
  isHome = home;
  isDarwin = darwin;
  isAndroid = nixOnDroid;
  isLinux = !isDarwin && !isWSL && !isAndroid && !isHome;

  flakeRoot = self;
  selectFlake = stable: unstable: if stability == "stable" then stable else unstable;

  # --- NIXOS (LINUX & WSL) ---
  nixosConfig = let
    pkgsIn = selectFlake inputs.nixos-stable inputs.nixos-unstable;
    hmModule = selectFlake inputs.home-manager-stable.nixosModules.home-manager inputs.home-manager-unstable.nixosModules.home-manager;
  in if (isLinux || isWSL) then pkgsIn.lib.nixosSystem {
    specialArgs = { inherit inputs system hostname username pkgsIn flakeRoot extraHomeModules isWSL isLinux isDarwin; };
    modules = [
      ../nixos/${hostname}/configuration.nix # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
      ../nixos/share                         # Global Configs for AllSystem 
      hmModule
    ] ++ (if isWSL then [ inputs.wsl.nixosModules.wsl ] else [ inputs.nix-snapd.nixosModules.default ])
      ++ extraModules; 
  } else { };

  # --- DARWIN ---
  darwinConfig = let
    pkgsIn = selectFlake inputs.nix-darwin-stable inputs.nix-darwin-unstable;
    hmModule = selectFlake inputs.home-manager-stable.darwinModules.home-manager inputs.home-manager-unstable.darwinModules.home-manager;
  in if isDarwin then pkgsIn.lib.darwinSystem {
    specialArgs = { inherit inputs system hostname username flakeRoot extraHomeModules isWSL isLinux isDarwin; };
    modules = [ 
      ../darwin/${hostname}/configuration.nix # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
      ../darwin/shared                        # Global Configs for AllSystem 
      hmModule 
    ] ++ extraModules;
  } else { };

  # --- HOME-MANAGER STANDALONE ---
  hmConfig = let
    pkgsIn = selectFlake inputs.nixos-stable inputs.nixos-unstable;
    hmLib = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;
  in if isHome then hmLib.lib.homeManagerConfiguration {
    pkgs = pkgsIn.legacyPackages.${system};
    extraSpecialArgs = { inherit system hostname username pkgsIn flakeRoot extraHomeModules isWSL isLinux isDarwin; 
      rootInputs = inputs;
    };
    # Global Home-manager Config,
    # extraHomeModules: for Specific/personal configurations (ex dotfiles)  
    modules = [ ../home/shared ] ++ extraHomeModules; 
  } else { };

  # --- LOGIKA NIX-ON-DROID ---
  androidConfig = let
    pkgsIn   = selectFlake inputs.nixos-stable inputs.nixos-unstable;
    hmModule = selectFlake inputs.home-manager-stable.nixosModules.home-manager inputs.home-manager-unstable.nixosModules.home-manager;
  in if isAndroid then inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import pkgsIn {
      inherit system;
      overlays = [ (import ./overlays args).default inputs.nix-on-droid.overlays.default ];
      config   = (import ./nixpkgs args).config;
    };
    extraSpecialArgs = { inherit inputs system hostname username pkgsIn flakeRoot isWSL isLinux isDarwin; };
    modules = [
      ../android/shared.nix # Global Configs for AllSystem 
      hmModule
      {
        home-manager = {
          useGlobalPkgs       = true;
          useUserPackages     = true;
          backupFileExtension = "hm-bak";
          # Global Home-manager Config,
          # extraHomeModules: for Specific/personal configurations (ex dotfiles)  
          config              = { imports = [ ../home/shared ] ++ extraHomeModules; }; 
        };
      }
    ] ++ extraModules;
  } else { };

in
nixosConfig // darwinConfig // hmConfig // androidConfig
