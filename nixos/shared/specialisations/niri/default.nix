# export from ../default.nix (system environtment)
{ pkgs, ... }:

{
	# specialisation.niri.configuration = {
	#   environment.systemPackages = with pkgs; [
	#   	niri
	#   ];

	#   services = {
	#   ###################################
	#   ## THUNAR OPTIMALIZATION
	#   #####################################
	# 		tumbler.enable = true; # thumbnails di Thunar  
	# 		dbus.enable = true;
	# 	  dbus.packages = with pkgs; [ dconf ];
	# 		udisks2.enable = true;
	# 		gvfs = {
	#         enable = true;
	#         package = pkgs.gnome.gvfs;
	#     };
	#   };

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

	# 	environment.sessionVariables = {
	# 		XDG_CURRENT_DESKTOP = "niri";
	# 		XDG_SESSION_TYPE = "wayland";
	# 	};	
	# };
}
