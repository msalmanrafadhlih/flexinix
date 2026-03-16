{inputs, ...}: let
  # ... This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # ... Tempat modifikasi 'Global' paket (Overlay)
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # --- Or define it inline, for example:
    # (final: prev: {
    #   hi = final.hello.overrideAttrs (oldAttrs: {
    #     patches = [ ./change-hello-to-hi.patch ];
    #   });
    # })
  };

  # Overlay untuk 'pkgs.stable'
  stable-packages = final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
in [
  additions
  modifications
  stable-packages
  inputs.Bloodrage-plymouth.overlays.default
  inputs.nur.overlays.default
]
