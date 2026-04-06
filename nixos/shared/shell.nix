# System Zsh Configuration
{ pkgs,  isLinux, isWSL, ... }: let
  aliases = import ./aliases.nix { inherit isWSL isLinux;};
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
  };

}
