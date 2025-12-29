{ config, pkgs, mango, ... }:
{
	home.username = "ang3lo";
	home.homeDirectory = "/home/ang3lo";

	imports = [
		mango.hmModules.mango
		../../modules/home-manager
	];

	programs.home-manager.enable = true;

	wayland.windowManager.mango = {
		enable = true;
	  #settings = builtins.readFile ./config/mango/config.conf;
	  #autostart_sh = builtins.readFile ./config/mango/autostart.sh;
	};

	# This value determines the home Manager release that your
	# configuration is compatible with. This helps avoid breakage
	# when a new home Manager release introduces backwards
	# incompatible changes.
	#
	# You can update home Manager without changing this value. See
	# the home Manager release notes for a list of state version
	# changes in each release.
	home.stateVersion = "25.11";
}
