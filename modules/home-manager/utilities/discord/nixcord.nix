{
  inputs,
  config,
  ...
}: {
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
      enable = false;
      vencord.enable = false;
      equicord.enable = true;
      commandLineArgs = [
        "--disable-gpu"
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer"
        "--ozone-platform-hint=auto"
      ];
    };
    equibop = {
      enable = true;
      settings = {
        discordBranch = "stable";
        tray = true;
        minimizeToTray = true;
        arRPC = true;
        trayColor = "";
        trayMainOverride = false;
        splashColor = "rgb(219, 220, 223)";
        hardwareVideoAcceleration = true;
        customTitleBar = false;
        staticTitle = false;
        enableMenu = false;
        enableSplashScreen = false;
        splashProgress = true;
        disableMinSize = true;
        badgeOnlyForMentions = true;
        openLinksWithElectron = true;
      };
    };
    dorion = {
      enable = true;
      clientMods = ["Shelter" "Equicord"];
    };
    config = {
      autoUpdate = true;
      plugins = {
        fakeNitro.enable = true;
        noNitroUpsell.enable = true;
        questify = {
          enable = true;
          allowChangingDangerousSettings = true;
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
        #spotifyActivityToggle.enable = true;
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
        };
        previewMessage.enable = true;
        noMiddleClickPaste.enable = true;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = ["${config.home.sessionVariables.DISCORD}.desktop"];
  };
}
