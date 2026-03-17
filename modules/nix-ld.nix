# ./default.nix
{ pkgs, ... }:

{
  # We require this because we use lazy.nvim against the best wishes
  # Enable Nix-ld for dynamic linking (running elf binaries)
  # a pure Nix system so this lets those unpatched binaries run.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages

  ];
}
