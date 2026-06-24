{inputs, ...}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    userPlugins = {
      fakeVoiceOptions = ./plugins/fakeVoiceOptions;
    };
    extraConfig = {
      plugins = {
        fakeVoiceOptions.enable = true;
      };
    };
    discord = {
      vencord.enable = false;
      equicord.enable = true;

      # TODO: Remove when nixcord fixes the openASAR
      #openASAR.enable = false;
    };
    config = {
      autoUpdate = true;
      plugins = {
        fakeNitro.enable = true;
        noNitroUpsell.enable = true;
        questify = {
          enable = true;
          #allowChangingDangerousSettings = true;
          autoCompleteQuestsSimultaneously = true;
          autoCompleteQuestTypes = {
            PLAY_ON_DESKTOP = true;
            PLAY_ON_XBOX = true;
            PLAY_ON_PLAYSTATION = true;
            PLAY_ACTIVITY = true;
            WATCH_VIDEO = true;
            WATCH_VIDEO_ON_MOBILE = true;
            ACHIEVEMENT_IN_ACTIVITY = true;
          };
          completeVideoQuestsQuicker = true;
          makeMobileVideoQuestsDesktopCompatible = true;
          resumeInterruptedQuests = true;
        };
        spotifyActivityToggle.enable = true;
        spotifyCrack = {
          enable = true;
          noSpotifyAutoPause = false;
        };
        musicControls = {
          enable = true;
          hoverControls = true;
          showSpotifyControls = true;
          showSpotifyLyrics = true;
          useSpotifyUris = true;
        };
        messageLoggerEnhanced.enable = true;
        channelTabs.enable = true;
        showHiddenChannels.enable = true;
        summaries.enable = true;
        splitLargeMessages = {
          enable = true;
          disableFileConversion = true;
        };
        previewMessage.enable = true;
      };
    };
  };
}
