{ pkgs, ... }:
{
	home.packages = with pkgs; [
		(callPackage ../../../../../pkgs/sstv/default.nix { })
	];
}
