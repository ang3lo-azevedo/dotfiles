{ pkgs, ... }:
{
	home.packages = with pkgs; [
		volatility2-bin
	];
}
