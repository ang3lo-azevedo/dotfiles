{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  # These programs panic if their config files are read-only.
  # This activation script replaces the Nixcord-generated symlinks with writable copies.
  home.activation.fixConfigFiles = lib.hm.dag.entryAfter ["linkGeneration"] ''
    for config_file in \
      "$HOME/.config/dorion/config.json" \
      "$HOME/.config/equibop/settings/settings.json"; do
      if [ -L "$config_file" ]; then
        real_file=$(readlink -f "$config_file")
        rm "$config_file"
        cp "$real_file" "$config_file"
        chmod 644 "$config_file"
      fi
    done
  '';

  programs.nixcord = {
    enable = true;
    userPlugins = {
      fakeVoiceOptions = ./plugins/fakeVoiceOptions;
      declarativeBookmarks = ./plugins/declarativeBookmarks;
    };
    extraConfig = {
      plugins = {
        fakeVoiceOptions.enable = true;
        declarativeBookmarks = {
          enable = true;
          bookmarks = builtins.toJSON {
            "286528030854217739" = let
              bookmark = guildId: channelId: name: {inherit guildId channelId name;};
            in [
              (bookmark "@me" "__quests__" "Quests")
              (bookmark "1529888082998988921" "1529888083439255766" "#general")
              (bookmark "829696536136777759" "1529927918040387654" "#important-info")
              {
                name = "CTFs";
                iconColor = "#ffc800";
                bookmarks = [
                  (bookmark "687810004002275510" "766773662833442897" "#general")
                  (bookmark "829696536136777759" "829696536656216086" "#general")
                ];
              }
              (bookmark "1482290323580387510" "1482290324347949068" "#geral")
              (bookmark "687810004002275510" "1155999542970421290" "#random")
              (bookmark "1526591904731369543" "1526591904731369546" "#general")
            ];
          };
        };
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
      # Electron's V4L2 enumeration skips the camera relay (a loopback that
      # advertises both capture and output), so reach it through PipeWire.
      # Chromium keeps only the last --enable-features, which would drop the
      # WaylandWindowDecorations the upstream wrapper passes, so repeat it.
      package = pkgs.equibop.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            wrapProgram $out/bin/equibop \
              --add-flags "--enable-features=WaylandWindowDecorations,WebRtcPipeWireCamera"
          '';
      });
      settings = {
        discordBranch = "stable";
        tray = true;
        minimizeToTray = true;
        arRPC = true;
        trayColor = "";
        trayMainOverride = false;
        splashColor = "rgb(219, 220, 223)";
        # Equibop turns this into AcceleratedVideoEncoder plus, on Linux,
        # AcceleratedVideoDecodeLinuxZeroCopyGL. The VA-API encoder pads a
        # stream whose height is not a multiple of 16 (1080 becomes 1088) and
        # the unfilled rows arrive as the green bar along the bottom of shared
        # screens and camera streams. Software encoding costs CPU during calls
        # but produces a clean frame.
        hardwareVideoAcceleration = false;
        customTitleBar = false;
        staticTitle = false;
        enableMenu = false;
        enableSplashScreen = false;
        splashProgress = true;
        disableMinSize = true;
        badgeOnlyForMentions = true;
      };
    };
    dorion = {
      #enable = true;
      package = pkgs.vorion;
      clientMods = [
        "Shelter"
        "Equicord"
      ];
    };
    quickCss = builtins.readFile ./quick.css;
    config = {
      autoUpdate = true;
      useQuickCss = true;
      plugins = {
        fakeNitro.enable = true;
        noNitroUpsell.enable = true;
        # questify = {
        #   enable = true;
        #   allowChangingDangerousSettings = true;
        #   autoCompleteQuestsSimultaneously = true;
        #   autoCompleteQuestTypes = {
        #     PLAY_ON_DESKTOP = true;
        #     PLAY_ON_XBOX = true;
        #     PLAY_ON_PLAYSTATION = true;
        #     PLAY_ACTIVITY = true;
        #     WATCH_VIDEO = true;
        #     WATCH_VIDEO_ON_MOBILE = true;
        #     ACHIEVEMENT_IN_ACTIVITY = true;
        #   };
        #   completeVideoQuestsQuicker = true;
        #   makeMobileVideoQuestsDesktopCompatible = true;
        #   resumeInterruptedQuests = true;
        # };
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
        channelTabs = {
          enable = true;
          bookmarksIndependentFromTabs = false;
          createNewTabIfNotExists = true;
          switchToExistingTab = true;
          openNewTabsInCompactMode = true;
          renderAllTabs = true;
          showTabNumbers = true;
        };
        # Links to embed fixers, so posts show their media in Discord. Each fixer was checked
        # to return an embed for a real post. The "://" anchor leaves links already pointing
        # at a fixer untouched, and only post paths are matched: profiles gain nothing.
        # Delimited with flags: a pattern ending in "/" would lose it and the "g" flag
        textReplace = {
          enable = true;
          regexRules = let
            rule = name: find: replace: {
              inherit name find replace;
              onlyIfIncludes = "";
              scope = "myMessages";
            };
          in [
            (rule "Twitter/X through fxtwitter"
              ''/https?:\/\/(?:www\.|mobile\.)?(?:twitter|x)\.com(?=\/)/gi''
              "https://fxtwitter.com")
            # instagramez.com and ddinstagram.com returned no embed
            (rule "Instagram through InstaFix"
              ''/https?:\/\/(?:www\.)?instagram\.com(?=\/(?:p|reels?|tv)\/)/gi''
              "https://uuinstagram.com")
            # fxTikTok; vm.tiktok.com short links are left alone, untested there
            (rule "TikTok through fxTikTok"
              ''/https?:\/\/(?:www\.|m\.)?tiktok\.com(?=\/@[^\s\/]+\/video\/)/gi''
              "https://tnktok.com")
            # rxddit.com answered with a 502; /s/ share links are left alone, untested there
            (rule "Reddit through vxreddit"
              ''/https?:\/\/(?:www\.|old\.|new\.)?reddit\.com(?=\/r\/[^\s\/]+\/comments\/)/gi''
              "https://vxreddit.com")
            (rule "Bluesky through FxBluesky"
              ''/https?:\/\/bsky\.app(?=\/profile\/[^\s\/]+\/post\/)/gi''
              "https://fxbsky.app")
          ];
        };
        middleClickTweaks.enable = true;
        showHiddenChannels.enable = true;
        previewMessage.enable = true;
        alwaysTrust.enable = true;
        alwaysAnimate.enable = true;
        addAttachments.enable = true;
        reactionTimestamps.enable = true;
        voiceMessagesInBackground.enable = true;
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = ["${config.home.sessionVariables.DISCORD}.desktop"];
  };
}
