{ inputs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    discord = {
      vencord.enable = false;
      equicord.enable = true;
    };
    config = {
      autoUpdate = true;
      plugins = {
        fakeNitro.enable = true;
        noNitroUpsell.enable = true;
        questify.enable = true;
        questCompleter.enable = true;
        spotifyActivityToggle.enable = true;
        spotifyCrack = {
          enable = true;
          noSpotifyAutoPause = false;
        };
        musicControls.enable = true;
        messageLoggerEnhanced.enable = true;
        channelTabs.enable = true;
        showHiddenChannels.enable = true;
        anammox = {
          enable = true;
        };
        summaries.enable = true;
      };
    };
  };
}
