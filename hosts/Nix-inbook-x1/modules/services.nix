{ ... }:

{
  # optimize nix-daemon resource usage
  systemd.services.nix-daemon.serviceConfig = {
    CPUQuota = "80%";
    IOSchedulingClass = "best-effort";
    IOSchedulingPriority = 4;
  };

  services = {
  	journald = {
		storage = "persistent";
		extraConfig = ''
			RuntimeMaxUse=50M
			SystemMaxUse=100M
			MaxRetentionSec=14day
			SystemMaxFileSize=10M
		'';
  	};
  };
}
