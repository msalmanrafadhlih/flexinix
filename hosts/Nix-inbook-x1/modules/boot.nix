{ pkgs, ... }:
let
  myTheme = "cuts";
in
{

	console = {
		earlySetup = false; # setup console dilakukan di initrd
		keyMap = "us";
	};

  boot = {
    loader = {
      timeout = 50; # infinite timeout (nunggu user 50 detik)

      grub = {
        enable = true;
        theme = pkgs.my-grub-theme;
        splashImage = null;
        efiSupport = true;
        device = "nodev"; # untuk UEFI
        useOSProber = false; # detect OS lain (optional)
        configurationLimit = 10; # limit generation

        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
      };

      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = myTheme;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ myTheme ];
        })
      ];
    };

    consoleLogLevel = 0;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.systemd.show_status=0"
      "rd.udev.log_level=0"
      "vt.global_cursor_default=0"
      "i915.fastboot=1"
      # "fbcon=nodefer" # ramebuffer console load lebih awal
    ];

    initrd = {
      verbose = false; # matikan output initrd
      systemd.enable = true;
      kernelModules = [
        "i915" # intel
        # "amdgpu" # amd
        # "nvidia-drm.modeset=1" # nvidia
      ];
    };
  };
}
