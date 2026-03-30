# System Zsh Configuration
{ pkgs, ... }: let
  aliases = import ./aliases.nix ;
in {

	users.defaultUserShell = pkgs.fish;
	
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

    programs.fish = {
      enable = true;
      shellAliases = aliases;
    };
  }; 
}
