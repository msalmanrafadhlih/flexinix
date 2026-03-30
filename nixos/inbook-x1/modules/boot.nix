{ pkgs, ... }:

{
  boot = {
    loader = {
      timeout = -1; # infinite timeout (nunggu user selamanya)

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev"; # untuk UEFI
        useOSProber = true; # detect OS lain (optional)
        configurationLimit = 10; # limit generation

        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
      };

      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "Bloodrage";
      themePackages = [ pkgs.bloodrage-plymouth ];
    };

    consoleLogLevel = 0;

    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=0"
      "vt.global_cursor_default=0"
      "rd.udev.log_level=0"
    ];

		initrd = {
			verbose = false; # matikan output initrd
			# systemd.enable = true;
			kernelModules = [
				"i915" # intel
				# "amdgpu" # amd
				# "nvidia-drm.modeset=1" # nvidia
			];
		};
  };
}
