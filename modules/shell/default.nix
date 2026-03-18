# System Zsh Configuration
{ pkgs, isDarwin, ... }:
{

	users.defaultUserShell = pkgs.zsh;
	
	programs = {
  	bash = {
  		enable = true;
  		shellAliases = import ./aliases.nix;
  	};

  	zsh = {
  	  enable = true;
  	  shellAliases = import ./aliases.nix;
  	  syntaxHighlighting.enable = true;
    };

	} // (if isDarwin then {
    programs.fish = {
      enable = true;
      shellAliases = import ./aliases.nix;
    };
  } else {});
}
