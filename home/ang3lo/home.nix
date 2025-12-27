{ config, pkgs, spicetify-nix, ... }:
{
	home.username = "ang3lo";
	home.homeDirectory = "/home/ang3lo";

	imports = [
		./modules/development.nix
		./modules/entertainment.nix
		./modules/gaming.nix
		./modules/utilities.nix
	];

	programs.home-manager.enable = true;

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
