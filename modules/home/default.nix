{ pkgs, ... }: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  config._module.args = {
    isDarwin  = isDarwin;
    isLinux   = isLinux;
  };

  imports = [
    ./variables.nix
    ./starship.nix
    ./lazygit.nix
    ./virtmanager
    ./serpl.nix # tui find and replace tool, good for integratinng with terminal editors
    ./btop.nix
    ./wezterm
    ./git.nix
    ./helix
    ./shell
    ./yazi
    ./tmux

    # ./zellij
  ];
  
  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";
  xdg.enable = true;
}
