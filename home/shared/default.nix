{ flakeRoot, ... }:

{
  imports = [
    ./virtmanager.nix
    ./variables.nix
    ./starship.nix
    ./lazygit.nix
    ./wezterm.nix
    ./serpl.nix # tui find and replace tool, good for integratinng with terminal editors
    ./btop.nix
    ./git.nix
    ./helix
    ./shell
    ./yazi
    ./tmux

    # ./zellij
  ];
  
  # insert home-manager config
  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;

  # Read the changelog before changing this value
  home.stateVersion = flakeRoot.stateVersion.linux;

  xdg.enable = true;
}
