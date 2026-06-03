{ pkgs, ... }:
{
	home.packages = with pkgs; [
		memprocfs
	];
}

