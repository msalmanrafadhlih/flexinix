# export from ../default.nix (system environtment)
{ pkgs, ... }:

{
	# specialisation.hyprland.configuration = {
	#   environment.systemPackages = with pkgs; [
	#   	hyprland
	#   ];

	#   programs = {
	# 		thunar = {
	# 			enable = true;
	# 			plugins = with pkgs; [
	# 				thunar-volman
	# 				thunar-dropbox-plugin
	# 				thunar-vcs-plugin
	# 				thunar-media-tags-plugin
	# 			];
	# 		};
	#   };

	#   #####################################
	#   ## XDG PORTAL 
	#   #####################################
	# 	xdg.portal = {
	# 		enable = true;
	# 		xdgOpenUsePortal = true;
	# 		extraPortals = with pkgs; [
	# 		  xdg-desktop-portal-hyprland
	# 		];
	# 		config = {
	# 		  common = {
	# 		    default = ["hyprland"];
	# 		  };
	# 		};
	# 	};

	# 	environment.sessionVariables = {
	# 		XDG_CURRENT_DESKTOP = "hyprland";
	# 		XDG_SESSION_TYPE = "wayland";
	# 	};	
	# };
}
