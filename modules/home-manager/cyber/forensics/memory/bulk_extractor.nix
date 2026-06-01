{ pkgs, ... }:
{
	home.packages = with pkgs; [
		bulk_extractor
	];
}
