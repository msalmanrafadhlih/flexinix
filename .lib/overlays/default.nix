# NOTE: final and prev -------

# final: = Use it when referring to a package that may have been modified by another overlay
# (such as final.system or final.callPackage).

# prev:  = Use if you want to refer to the original package from nixpkgs before modification.

{ inputs, self, ... }:
rec {
  # Overlay for 'pkgs.stable' 'pkgs.unstable'
  all-channels = final: prev: {
    stable = import inputs.nixos-stable {
      system = prev.stdenv.hostPlatform.system;
      config = self.nixpkgs.config;
    };
    unstable = import inputs.nixos-unstable {
      system = prev.stdenv.hostPlatform.system;
      config = self.nixpkgs.config;
    };
  };

  default = inputs.nixos-stable.lib.composeManyExtensions [
    all-channels
  ];
}
