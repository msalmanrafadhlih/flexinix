{
  # tool otomatis untuk mengatur
  # konsumsi daya hardware di Linux.
  services.tlp = { 
  	enable = true;
  	settings = {
  		USB_AUTOSUSPEND = 0;
  	};
  };
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
