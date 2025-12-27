{ config, pkgs, ... }:
{
	home.username = "ang3lo";
	home.homeDirectory = "/home/ang3lo";
	home.stateVersion = "24.11";

	programs.home-manager.enable = true;

	home.packages = with pkgs; [
		# User-level packages go here.
	];
}
