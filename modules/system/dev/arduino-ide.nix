{ pkgs, lib, config, ... }:
{
	environment.systemPackages = with pkgs; [
		arduino-ide
	];

	users.groups.dialout.members = lib.mapAttrsToList (name: user: name) 
		(lib.filterAttrs (name: user: user.isNormalUser) config.users.users);
}
