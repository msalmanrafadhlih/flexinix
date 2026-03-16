{ pkgs, ... }:

{
  # Bootloader
	boot.loader.timeout = 5;
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.configurationLimit = 5;

	# Splash Screen
	boot = {
		plymouth = {
			enable = true;
			# THEMES = details, glow, script, spinfinity, Bloodrage,
			# spinner, breeze, fade-in, nixos, solar, text, tribar
			theme = "Bloodrage"; 
			themePackages = [ pkgs.Bloodrage-plymouth ];
			extraConfig = "";
			# logo = pkgs.fetchurl {
			# 	url = "https://raw.githubusercontent.com/Melkor333/nixos-boot/refs/heads/main/src/evil-nixos.png";
			# 	sha256 = "sha256-U/NgApBDrc40Q5VZkq4iuzEdOuR6Ne5QvpHbxJjg+iU=";
			# };
		};
		consoleLogLevel = 0; # set level log kernel (0=sepi, 7=verbose)
		kernelParams = [
			# untuk cek log,
			# hapus quit dan log_level=7 jika error,
			"quiet" 
			"splash"
			"rd.systemd.show_status=0"
			"vt.global_cursor_default=0"
			"rd.udev.log_level=0" 
		];
	};


	boot.initrd = {
		verbose = false; # matikan output initrd
		# systemd.enable = true;
		kernelModules = [
			"i915" # intel
			# "amdgpu" # amd
			# "nvidia-drm.modeset=1" # nvidia
		];
	};
}
