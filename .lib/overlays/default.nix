# NOTE: final and prev -------

# final: = Use it when referring to a package that may have been modified by another overlay
# (such as final.system or final.callPackage).

# prev:  = Use if you want to refer to the original package from nixpkgs before modification.

inputs: rec {
  # ... This one brings our custom packages from the 'pkgs' directory
  local-packages = (final: prev: import ../packages {pkgs = final; inherit inputs;});

  # Overlay for 'pkgs.stable' 'pkgs.unstable'
  all-channels = final: prev: {
    stable = import inputs.nixos-stable {
      system = prev.stdenv.hostPlatform.system;
			config = ( import ../nixpkgs inputs ).config;
    };
    unstable = import inputs.nixos-unstable {
      system = prev.stdenv.hostPlatform.system;
			config = ( import ../nixpkgs inputs ).config;
    };
  };

  devenv = (final: prev: { devenv = inputs.devenv.packages.${prev.stdenv.hostPlatform.system}.devenv; });


  default = inputs.nixos-stable.lib.composeManyExtensions [
    local-packages
    all-channels
    devenv

    inputs.nur.overlays.default
  ];
}
