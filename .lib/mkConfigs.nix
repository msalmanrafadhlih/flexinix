{ inputs, self, ... }@args: let

	flakeRoot = self;
in
{
	nixos = hostname: { username, stability ? "stable", system ? "x86_64-linux", extraModules ? [], wsl ? false }: let
		isWSL   = wsl;
		isLinux = !isWSL;
		
		selecFlake  = stable: unstable: { inherit stable unstable; }.${stability};
		nixpkgs     = selecFlake inputs.nixos-stable inputs.nixos-unstable;
		homeManager = selecFlake inputs.home-manager-stable.nixosModules inputs.home-manager-unstable.nixoModules;
		
	  userConfig    = ../nixos/${hostname}/configuration.nix; # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
 	  sharedConfig  = ../nixos/shared ;                       # Global Configs for AllSystem.

		in nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs system hostname username nixpkgs homeManager extraModules isWSL isLinux flakeRoot; };
			modules = [

		    # Bring in WSL if this is a WSL build
		    (if isWSL then inputs.nixos-wsl.nixosModules.wsl else {})

		    # Snapd on Linux
		    (if isLinux then inputs.nix-snapd.nixosModules.default else {})

				userConfig
				sharedConfig
			];
		};

	darwin = hostname: { username, stability ? "stable", system ? "aarch64-darwin", extraModules ? [] }: let
		selecFlake  = stable: unstable: { inherit stable unstable; }.${stability};
		nixpkgs     = selecFlake inputs.darwin-stable inputs.darwin-unstable;
		homeManager = selecFlake inputs.home-manager-stable.darwinModules inputs.home-manager-unstable.darwinModules;
		
	  userConfigs   = ../darwin/${hostname}/configuration.nix; # Spesific Configs for Current system/Machine (ex Hardware, Utilities etc)
 	  sharedConfigs = ../darwin/shared ;                       # Global Configs for AllSystem.

		in inputs.nix-darwin.lib.darwinSystem {
			specialArgs = { inherit inputs system hostname username nixpkgs homeManager extraModules flakeRoot; };
			modules = [ userConfigs sharedConfigs userHMConfig ];
		};

	home = username: { stability ? "stable", system, extraHomeModules ? [] }: let
		selecFlake  = stable: unstable: { inherit stable unstable; }.${stability};
		nixpkgs     = selecFlake inputs.nixos-stable inputs.nixos-unstable;
		homeManager = selecFlake inputs.home-manager-stable inputs.home-manager-unstable;
		
		userHMConfig  = ../home/shared; # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles) 

		in homeManager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.${system};
			extraSpecialArgs = { inherit system username nixpkgs homeManager extraHomeModules flakeRoot; };
			modules = [ userHMConfig extraHomeModules ];
		};


	nixOnDroid = hostname: { username, stability ? "stable", system ? "aarch64-linux", extraHomeModules ? [] }: let
		selecFlake  = stable: unstable: { inherit stable unstable; }.${stability};
		nixpkgs     = selecFlake inputs.nixos-stable inputs.nixos-unstable;
		homeManager = selecFlake inputs.home-manager-stable inputs.home-manager-unstable;
		
 	  sharedConfigs = ../android/shared.nix ;                # Global Configs for AllSystem.
		userHMConfig  = [ ../home/shared ] ++ extraHomeModules;   # Global Home-manager Config, extraHomeModules: for Specific/personal configurations (ex dotfiles) 

		in inputs.nix-on-droid.lib.nixOnDroidConfiguration {
			pkgs = import nixpkgs {
				inherit system;
				overlays = [ ( import ./overlays args ).default inputs.nix-on-droid.overlays.default ];
				config = ( import ./nixpkgs args ).config;
			};
			extraSpecialArgs = { inherit system hostname username nixpkgs homeManager extraHomeModules flakeRoot; };
			home-manager-path = homeManager.outPath;
			modules = [
				sharedConfigs
				{
				  home-manager = {
				    useGlobalPkgs = true;
				    useUserPackages = true;
				    backupFileExtension = "hm-bak";
				    config = userHMConfig;
				  };			
				}
			];
		};

}
