{ config, lib, pkgs, ...}:
{
	boot = {
		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
			timeout = 0;
		};
		tmp.cleanOnBoot = true;
		supportedFilesystems = [ "ntfs" "exfat" ];
		kernelParams = [ "quite" "splash" "loglevel=0" ];
		initrd = {
			verbose = false;
		};
		consoleLogLevel = 0;
		plymouth.enable = true;
	};

	systemd = {
		watchdog.rebootTime = "0";
		targets.network-online.wantedBy = pkgs.lib.mkForce [ ]; # Normally ["multi-user.target"]
		services = {
			systemd-udev-settle.enable = false;
			NetworkManager-wait-online = {
				enable = false;
				wantedBy = pkgs.lib.mkForce [ ]; # Normally ["network-online.target"]
			};
		};
	};
}
