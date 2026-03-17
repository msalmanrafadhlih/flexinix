{ ... }:
{
  imports = [
    ./variables.nix
    ./starship.nix
    ./lazygit.nix
    ./virtmanager/default.nix
    ./serpl.nix # tui find and replace tool, good for integratinng with terminal editors
    ./btop.nix
    ./wezterm/default.nix
    ./git.nix
    ./helix/default.nix
    ./shell/default.nix
    ./yazi/default.nix
    ./tmux/default.nix

    # ./zellij/default.nix
  ];
  
  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";
  xdg.enable = true;
}
