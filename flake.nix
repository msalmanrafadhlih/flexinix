{
  description = "flexinix";
 
  outputs = { self, ... }@inputs: let

    # custom libraries
    mylibs = import ./.lib {
      inherit inputs self;
    };
  in {
    # set your profile systems here!
    stateVersion = "25.11";
    timezone = "Asia/Jakarta";

    overlays                 = mylibs.overlays;       # overlays.default is the sum of all the overlays
    packages                 = mylibs.packages;       # custom packages built against nixpkgs
    devShells                = mylibs.devShells;
    legacyPackages           = mylibs.legacyPackages; # applies overlays.default to nixpkgs.legacyPackages
    systemConfigs            = mylibs.systemConfigs;
    schemas                  = mylibs.schemas;        # not merged yet: https://github.com/NixOS/nix/pull/8892

    nixosConfigurations      = import ./nixosConfigurations      { inherit inputs; inherit (mylibs) mkConfigs; };
    homeConfigurations       = import ./homeConfigurations       { inherit inputs; inherit (mylibs) mkConfigs; };
    darwinConfigurations     = import ./darwinConfigurations     { inherit inputs; inherit (mylibs) mkConfigs; };
    nixOnDroidConfigurations = import ./nixOnDroidConfigurations { inherit inputs; inherit (mylibs) mkConfigs; }; # nix-on-droid switch --flake github:msalmanrafadhlih/flexinix
  };

  inputs = {
    # /// nixpkgs version ///////////////////////////////////////////////
    # /// take it from the registry /////////////////////////////////////
    # - `nix registry add nixpkgs github:NixOS/nixpkgs/<some-branch-version>`
    nixpkgs                  = { type = "indirect"; id = "nixpkgs"; };
    # - nixos Stable
    nixos-stable.url         = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-stable-lib.url     = "github:NixOS/nixpkgs/nixos-25.11?dir=lib"; # "github:nix-community/nixpkgs.lib" doesn't work
    nixos-stable-small.url   = "github:NixOS/nixpkgs/nixos-25.11-small";
    # - nixos Unstable
    master.url               = "github:NixOS/nixpkgs/master";
    nixos-unstable.url       = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-lib.url   = "github:NixOS/nixpkgs/nixos-unstable?dir=lib";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # /// system-manager ////////////////////////////////////////////////
    # - Home-Manager
    home-manager-stable      = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixos-stable-lib"; };
    home-manager-unstable    = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixos-unstable-lib"; };
    # - Nix-Darwin
    nix-darwin               = { url = "github:lnl7/nix-darwin/master"; inputs.nixpkgs.follows = "nixos-stable-lib"; };
    darwin-stable.url        = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    darwin-unstable.url      = "github:NixOS/nixpkgs/nixpkgs-unstable"; # darwin-unstable for now (https://github.com/NixOS/nixpkgs/issues/107466)
    # - Nix-WSL
    wsl                      = { url = "github:nix-community/NixOS-WSL"; inputs.nixpkgs.follows = "nixos-stable-lib"; };
    # - Nix-on-Droid
    nix-on-droid             = { url = "github:nix-community/nix-on-droid/master";
      inputs                 = { nixpkgs.follows = "nixos-stable-lib";
        home-manager.follows = "home-manager-stable";
      };
    };

    # /// core_ecosystems ///////////////////////////////////////////////
    flake-schemas.url        = "github:DeterminateSystems/flake-schemas"; # tool: validator scheme for flake > `nix flake check` 
    flake-utils.url          = "github:numtide/flake-utils"; # MultiSystem helper 
    flake-compat             = { url = "github:edolstra/flake-compat"; flake = false; }; # tool = nonflake 
    flake-parts              = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixos-stable-lib"; }; # tool = Modular Flake 
    
    # /// development_tools ////////////////////////////////////////////
    devshell                 = { url = "github:numtide/devshell"; inputs.nixpkgs.follows = "nixos-stable-lib"; };
    devenv                   = { url = "github:cachix/devenv";
      inputs                 = { flake-compat.follows = "flake-compat";
        git-hooks.follows    = "git-hooks";
      };
    };

    # /// security/secret_tools ////////////////////////////////////////
    sops-nix.url             = "github:Mic92/sops-nix";

    # /// package_managers /////////////////////////////////////////////
    nur.url                  = "github:nix-community/NUR";
  };
}
