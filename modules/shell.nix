# System Zsh Configuration
{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {

	users.defaultUserShell = pkgs.zsh;
	
	program = {
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
