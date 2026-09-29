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
        openLinksWithElectron = true;
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
    # The Stylix theme maps Discord's blurple to base0B (green) and its brand
    # accent to base0F (magenta), so pull both back to the blue accent.
    quickCss = ''
      :root, .visual-refresh, .theme-dark, .theme-light {
        --blurple-50: var(--base0D) !important;
        --brand-500: var(--base0D) !important;
      }
      .visual-refresh path[fill^="rgba(88, 101, 242, 1)"] {
        fill: var(--base0D) !important;
      }
    '';
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
        channelTabs.enable = true;
        showHiddenChannels.enable = true;
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
