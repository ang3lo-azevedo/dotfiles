{ pkgs, ... }:
{
  # Enable Steam at the system level
  programs.steam = {
    enable = true;

    # Enable Gamescope session for Steam Deck-like experience
    gamescopeSession.enable = true;

    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

    protontricks.enable = true;
  };

  # Enable Proton GE for better game compatibility
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
}
