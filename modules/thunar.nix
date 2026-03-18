{ pkgs, ... }: {
  
  programs = {
		thunar = {
			enable = true;
			plugins = with pkgs; [
				thunar-volman
				thunar-dropbox-plugin
				thunar-vcs-plugin
				thunar-media-tags-plugin
			];
		};
  };

  imports = [
    # ./file-network.nix
  ];
}
