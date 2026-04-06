{ flakeRoot, ... }:

{

  _module.args = {
    isDarwin  = true;
    isLinux   = false;
    isWSL     = false;
    isAndroid = false;
  };

  imports = [
    ./shared/virtmanager.nix
    ./shared/variables.nix
    ./shared/starship.nix
    ./shared/lazygit.nix
    ./shared/wezterm.nix
    ./shared/serpl.nix # tui find and replace tool, good for integratinng with terminal editors
    ./shared/btop.nix
    ./shared/git.nix
    ./shared/helix
    ./shared/shell
    ./shared/yazi
    ./shared/tmux

    # ./zellij
  ];
  
  # insert home-manager config
  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;

  # Read the changelog before changing this value
  home.stateVersion = flakeRoot.stateVersion.linux;

  xdg.enable = true;
}
