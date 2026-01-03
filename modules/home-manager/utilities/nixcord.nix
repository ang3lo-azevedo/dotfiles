{ inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    equibop.enable = true;
    config = {
      autoUpdate = true;
      plugins = {
        questify.enable = true;
        spotifyActivityToggle.enable = true;
        spotifyCrack = {
          enable = true;
          noSpotifyAutoPause = false;
        };
        musicControls.enable = true;
        messageLoggerEnhanced.enable = true;
        channelTabs.enable = true;
        showHiddenChannels.enable = true;
      };
    };
  };

  # Fix the .desktop entry for Equibop
  xdg.desktopEntries.equibop = {
    name = "Equibop";
    genericName = "Internet Messenger";
    exec = "equibop";
    icon = "discord";
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
  };
}
