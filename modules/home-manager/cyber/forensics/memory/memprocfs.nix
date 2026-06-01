{ pkgs, inputs, ... }:
{
	home.packages = with pkgs; [
		(inputs.dmatools.packages.x86_64-linux.memprocfs)
	];
}

