{ inputs, self, ... }@args: let

	flakeRoot = self;

	nixpkgs = {
		overlays = [ ( import ./overlays args ).default ];
		config = ( import ./nixpkgs args ).config;
	};
in
{
	nixos = hostname: stability: { username, system ? "x86_64-linux", extraModules ? [], wsl ? false }: let
		isWSL     = wsl;
    isDarwin  = false;
    isAndroid = false;
    isLinux   = !isWSL;
		
		selecFlake = stable: unstable: { inherit stable unstable; }.${stability};
		pkgsIn     = selecFlake inputs.nixos-stable inputs.nixos-unstable;
		hmModule   = selecFlake inputs.home-manager-stable.nixosModules.home-manager inputs.home-manager-unstable.nixosModules.home-manager;

	  userConfigs   = ../nixos/${hostname}/configuration.nix; # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
 	  sharedConfigs = ../nixos/shared ;                       # Global Configs for AllSystem.

		in pkgsIn.lib.nixosSystem {
			specialArgs = { inherit inputs system hostname username pkgsIn flakeRoot isWSL isLinux isAndroid isDarwin; };
			modules = [ nixpkgs userConfigs sharedConfigs hmModule
      ] ++ (if isWSL then [ inputs.nixos-wsl.nixosModules.wsl ] else [ inputs.nix-snapd.nixosModules.default ])
        ++ extraModules; 
		};

	darwin = hostname: stability: { username, system ? "aarch64-darwin", extraModules ? [] }: let
		isWSL     = false;
    isDarwin  = true;
    isAndroid = false;
    isLinux   = false;

		selecFlake    = stable: unstable: { inherit stable unstable; }.${stability};
		pkgsIn        = selecFlake inputs.darwin-stable inputs.darwin-unstable;
		hmModules     = selecFlake inputs.home-manager-stable.darwinModules.home-manager inputs.home-manager-unstable.darwinModules.home-manager;
		
	  userConfigs   = ../darwin/${hostname}/configuration.nix; # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
 	  sharedConfigs = ../darwin/shared ;                       # Global Configs for AllSystem.

		in inputs.nix-darwin.lib.darwinSystem {
			specialArgs = { inherit inputs system hostname username pkgsIn flakeRoot isWSL isLinux isAndroid isDarwin; };
			modules = [ nixpkgs userConfigs sharedConfigs hmModules ] ++ extraModules;
		};

	home = hostname: stability: { username, system, extraHomeModules ? [],
    nixOnDroid ? false,
    darwin ? false,
    wsl ? false
    }: let
    isWSL     = wsl;
    isDarwin  = darwin;
    isAndroid = nixOnDroid;
    isLinux   = !isDarwin && !isWSL && !isAndroid;

    selecFlake  = stable: unstable: { inherit stable unstable; }.${stability};
		pkgsIn      = selecFlake inputs.nixos-stable inputs.nixos-unstable;
		hmManager   = selecFlake inputs.home-manager-stable inputs.home-manager-unstable;
		
		userHMConfig  = ../home/shared; # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles) 

		in hmManager.lib.homeManagerConfiguration {
			pkgs = pkgsIn.legacyPackages.${system};
      extraSpecialArgs = { inherit system hostname username pkgsIn flakeRoot isWSL isLinux isDarwin isAndroid; 
        rootInputs = inputs;
      };
			modules = [ nixpkgs userHMConfig ] ++ extraHomeModules;
		};


	nixOnDroid = hostname: stability: { username, system ? "aarch64-linux", extraModules ? [], extraHomeModules ? [] }: let
		isWSL     = false;
    isDarwin  = false;
    isAndroid = true;
    isLinux   = false;

		selecFlake  = stable: unstable: { inherit stable unstable; }.${stability};
		pkgsIn      = selecFlake inputs.nixos-stable inputs.nixos-unstable;
		hmManager   = selecFlake inputs.home-manager-stable inputs.home-manager-unstable;
		
 	  sharedConfigs = ../android/shared.nix ;                   # Global Configs for AllSystem.
		userHMConfig  = [ ../home/shared ] ++ extraHomeModules;   # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles) 

		in inputs.nix-on-droid.lib.nixOnDroidConfiguration {
			pkgs = import pkgsIn {
				inherit system;
				overlays = [ ( import ./overlays args ).default inputs.nix-on-droid.overlays.default ];
				config   = ( import ./nixpkgs args ).config;
			};
			extraSpecialArgs = { inherit inputs system hostname username pkgsIn flakeRoot isWSL isLinux isAndroid isDarwin; };
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
