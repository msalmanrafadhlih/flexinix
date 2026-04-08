{ pkgs, ... }: {
  services.xserver.videoDrivers = [ "modesetting" ];

	hardware.graphics = {
	  enable = true;
	  enable32Bit = true;

	  extraPackages = with pkgs; [
	    intel-media-driver # driver modern untuk iGPU Intel (UHD/Iris)
	    intel-vaapi-driver # fallback untuk GPU Intel lama
	    libvdpau-va-gl # kompatibilitas VDPAU (opsional tapi aman)
	  ];
	};

	environment.sessionVariables = {
	  LIBVA_DRIVER_NAME = "iHD";
	};

	# KEYBOARD SETTINGS
	###################
	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	zramSwap = {
		enable = true;
		priority = 100;
		memoryPercent = 50;
	};

}

