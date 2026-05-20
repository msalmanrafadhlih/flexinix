{ flakeRoot, username, ... }:
let
  editor = {
    nvim = ./neovim;
    hx   = ./helix;
    vim  = ./vim;
  };
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.git.enable = true;

  imports = [
    ./variables.nix
    ./starship.nix
    ./lazygit.nix
    ./virtmanager
    ./serpl.nix # tui find and replace tool, good for integratinng with terminal editors
    ./btop.nix
    ./git.nix
    ./shell
    ./yazi
    ./tmux

    # ./zellij
    # ./wezterm
    editor.${flakeRoot.editor}
  ];

  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = flakeRoot.stateVersion.linux;
  xdg.enable = true;
}
