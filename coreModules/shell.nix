# System Zsh Configuration
{ pkgs, isDarwin, isLinux, isWSL, isAndroid, ... }: let
  aliases = import ./aliases.nix { inherit isWSL isLinux isDarwin isAndroid;};
in {

	users.defaultUserShell = pkgs.zsh;
	
	programs = {
  	bash = {
  		enable = true;
  		shellAliases = aliases;
  	};

  	zsh = {
  	  enable = true;
  	  shellAliases = aliases;
  	  syntaxHighlighting.enable = true;
    };

	} // (if isDarwin then {
    programs.fish = {
      enable = true;
      shellAliases = aliases;
    };
  } else {});
}
