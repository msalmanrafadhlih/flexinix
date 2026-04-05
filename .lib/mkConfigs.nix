{ inputs, self, ... }@args: let

	flakeRoot = self;

	selectFlake = stability: stable: unstable: if stability == "stable" then stable else unstable;

	nixpkgs = {
		nixpkgs.overlays = [ ( import ./overlays args ).default ];
		nixpkgs.config = ( import ./nixpkgs args ).config;
	};
in
{
	nixos = stability: { hostname, username, system ? "x86_64-linux", extraModules ? [], wsl ? false }: let
		isWSL     = wsl;
    isLinux   = !isWSL;
		
		pkgsIn     = selectFlake inputs.nixos-stable inputs.nixos-unstable;
		hmModule   = selectFlake inputs.home-manager-stable.nixosModules.home-manager inputs.home-manager-unstable.nixosModules.home-manager;

	  userConfigs   = ../nixos/${hostname}/configuration.nix; # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
 	  sharedConfigs = ../nixos/shared ;                       # Global Configs for AllSystem.

		in pkgsIn.lib.nixosSystem {
			specialArgs = { inherit inputs system hostname username pkgsIn flakeRoot isWSL isLinux; };
			modules = [ nixpkgs userConfigs sharedConfigs hmModule
      ] ++ (if isWSL then [ inputs.nixos-wsl.nixosModules.wsl ] else [ inputs.nix-snapd.nixosModules.default ])
        ++ extraModules; 
		};

	darwin = stability: { hostname, username, system ? "aarch64-darwin", extraModules ? [] }: let
		pkgsIn        = selectFlake inputs.darwin-stable inputs.darwin-unstable;
		hmModules     = selectFlake inputs.home-manager-stable.darwinModules.home-manager inputs.home-manager-unstable.darwinModules.home-manager;
		
	  userConfigs   = ../darwin/${hostname}/configuration.nix; # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
 	  sharedConfigs = ../darwin/shared ;                       # Global Configs for AllSystem.

		in inputs.nix-darwin.lib.darwinSystem {
			specialArgs = { inherit inputs system hostname username pkgsIn flakeRoot; };
			modules = [ nixpkgs userConfigs sharedConfigs hmModules ] ++ extraModules;
		};

	home = stability: { hostname, username, system, extraHomeModules ? [],
    nixOnDroid ? false,
    darwin ? false,
    wsl ? false
    }: let

    platform =
      if darwin then "darwin"
      else if nixOnDroid then "nixOnDroid"
      else if wsl then "wsl"
      else "nixos";

		pkgsIn      = selectFlake inputs.nixos-stable inputs.nixos-unstable;
		hmManager   = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;

		# Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles) 
		userHMConfig = ../home/shared/${platform}.nix;

		in hmManager.lib.homeManagerConfiguration {
			pkgs = pkgsIn.legacyPackages.${system};
      extraSpecialArgs = { inherit system hostname username pkgsIn flakeRoot; 
        rootInputs = inputs;
      };
			modules = [ nixpkgs userHMConfig ] ++ extraHomeModules;
		};


	nixOnDroid = stability: { hostname, username, system ? "aarch64-linux", extraModules ? [], extraHomeModules ? [] }: let
		pkgsIn      = selectFlake inputs.nixos-stable inputs.nixos-unstable;
		hmManager   = selectFlake inputs.home-manager-stable inputs.home-manager-unstable;
		
 	  sharedConfigs = ../android/shared.nix ;                   # Global Configs for AllSystem.
		userHMConfig  = [ ../home/nixOnDroid.nix ] ++ extraHomeModules;   # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles) 

		in inputs.nix-on-droid.lib.nixOnDroidConfiguration {
			pkgs = import pkgsIn {
				inherit system;
				overlays = [ ( import ./overlays args ).default inputs.nix-on-droid.overlays.default ];
				config   = ( import ./nixpkgs args ).config;
			};
			extraSpecialArgs = { inherit inputs system hostname username pkgsIn flakeRoot; };
			home-manager-path = hmManager.outPath;
			modules = [
				sharedConfigs
				{
				  home-manager = {
				    useGlobalPkgs = true;
				    useUserPackages = true;
				    backupFileExtension = "hm-bak";
				    config = { imports = userHMConfig; };
				  };			
				}
			] ++ extraModules;
		};

}
