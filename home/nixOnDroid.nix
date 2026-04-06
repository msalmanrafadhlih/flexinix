{ flakeRoot, ... }:

{

  _module.args = {
    isDarwin  = false;
    isLinux   = false;
    isWSL     = false;
    isAndroid = true;
  };

  imports = [
    ./shared/serpl.nix # tui find and replace tool, good for integratinng with terminal editors
    ./shared/git.nix
    ./shared/helix
    ./shared/shell
    ./shared/yazi
  ];
  
  # insert home-manager config
  # Disabled for now since we mismatch our versions. See flake.nix for details.
  home.enableNixpkgsReleaseCheck = false;

  # Read the changelog before changing this value
  home.stateVersion = flakeRoot.stateVersion.linux;

  xdg.enable = true;
}
