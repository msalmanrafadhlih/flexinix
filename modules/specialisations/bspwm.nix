# export from ../default.nix (system environtment)
{ pkgs, ... }:

{
	specialisation.bspwm.configuration = {
	  environment.systemPackages = with pkgs; [
	    # ======== BSPWM Stuff
	    polybarFull
	    sxhkd
	    picom
	    rofi
	    eww
	    i3lock-color
    
	    # ======== TOOLS
	    sound-theme-freedesktop
	    libcanberra-gtk3
	    mpv-unwrapped
	    brightnessctl
	    flameshot
	    imagemagick
	    clipmenu
	    pamixer
	    xclip # Clipboard
	    dunst
		  kdocker
			qview
	    maim
	    feh
	    bc

	    # ======== UTILS
	    imlib2
	    xinit
	    psmisc
	    xsetroot
	    xrandr
	    xinput
	    xdotool
	    xcolor
	    xev # key(board) mapping
	  ];

		security.pam.services.i3lock.enable = true;
		security.pam.services.i3lock = { };
		security.pam.services.i3lock.text = ''
			auth include login
		'';

	  services = {
	  #############################
	  ## WINDOW MANAGER SETTINGS
	  #############################
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

	  ###################################
	  ## THUNAR OPTIMALIZATION
	  #####################################
			tumbler.enable = true; # thumbnails di Thunar  
			dbus.enable = true;
		  dbus.packages = with pkgs; [ dconf ];
			udisks2.enable = true;
			gvfs = {
	        enable = true;
	        package = pkgs.gnome.gvfs;
	    };
	  };

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

		environment.sessionVariables = {
			XDG_CURRENT_DESKTOP = "bspwm";
			XDG_SESSION_TYPE = "x11";
		};	
	};
}
