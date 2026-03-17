{
  description = "nixos config (cleaned)";

  inputs = {
    nixpkgs-stable.url  = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    ## ------ Overlays
    Bloodrage-plymouth = {
      url = "github:TQ-See/NixPlymouth-Bloodrage";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager configurations
    racooonfig = {
      # url = "github:msalmanrafadhlih/racooonfig";
      url = "path:./development"; # for local testing
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, racooonfig, ... }@inputs:
  let
    flakeRoot = self.outPath;
    systems   = [ "aarch64-linux" "i686-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    mkSystem  = import ./lib/mksystem.nix {
      inherit  nixpkgs inputs flakeRoot;
    };
  in
  {
    # custom packages Accessible through 'nix build', 'nix shell', etc
    packages  = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # NixOS funcion : host { arch; username; extraModules; wsl; darwin; }
    # sudo nixos-rebuild (switch | build-vm) --flake ./#( infinix | wsl | mac ... )
    nixosConfigurations.infinix = mkSystem "inbook-x1" {
      system   = "x86_64-linux";
      username = "tquilla";
      extraModules = [ racooonfig.homeModules.default ];
    };

    nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
      system   = "aarch64-linux";
      username = "tquilla-vm";
    };

    nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" {
      system   = "aarch64-linux";
      username = "tquilla-vm";
    };

    nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" {
      system   = "aarch64-linux";
      username = "tquilla-vm";
    };

    nixosConfigurations.wsl = mkSystem "wsl" {
      system   = "x86_64-linux";
      username = "tquilla";
      wsl      = true;
    };

    darwinConfigurations.macbook = mkSystem "darwin" {
      system   = "aarch64-darwin";
      username = "tquilla";
      darwin   = true;
    };
  };
}
