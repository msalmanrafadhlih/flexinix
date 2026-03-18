# export from ../default.nix (system environtment)
{ ... }:
{
	specialisation.bspwm.configuration = {
		inports = [
			./packages.nix
			./services.nix
			./xdg-portal.nix
		];

	  services = {
	    xserver = {
	      enable = true;
	      # xkb = {
	      #   layout = "us";
	      # };
	      windowManager = {
	          bspwm.enable = true;
	      };
	      autoRepeatDelay = 300;
	      autoRepeatInterval = 35;
	      displayManager = {
	      	# startx.enable = true; # disable if set lightdm to true
	      	lightdm = {
	      		enable = true;
		        background = builtins.fetchurl {
		          url = "https://raw.githubusercontent.com/msalmanrafadhlih/Nixos-Dotsfile/refs/heads/main/config/Assets/Wallpaper/wallpaper8.jpeg";
		          sha256 = "sha256-VZp1wy2N0GApt48ILRY+pIAhAjCt02GmqmxHRTWAEoA=";
		        };
	      	};
	      };
	    };
	  };

		environment.sessionVariables = {
			XDG_CURRENT_DESKTOP = "bspwm";
			XDG_SESSION_TYPE = "x11";
		};	
	};
}
