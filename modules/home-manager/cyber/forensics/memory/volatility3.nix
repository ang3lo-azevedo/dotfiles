{ pkgs, ... }:
{
	home.packages = with pkgs; [
		volatility3
	];
}
