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
        openLinksWithElectron = false;
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
    # The Stylix theme maps Discord's blurple to base0B (green), its brand
    # accent to base0F (magenta) and the rest of the brand slots to base0D, so
    # pull all of them to white. Discord draws white text, icons and toggle
    # knobs on top of the accent, so those flip to black to stay readable.
    quickCss = ''
      :root, .visual-refresh, .theme-dark, .theme-light {
        --blurple-50: var(--base07) !important;
        --blurple-60: var(--base06) !important;
        --blurple-65: var(--base05) !important;
        --brand-260: var(--base07) !important;
        --brand-360: var(--base07) !important;
        --brand-500: var(--base07) !important;
        --button-filled-brand-background: var(--base07) !important;
        --control-brand-foreground-new: var(--base07) !important;

        --control-primary-text-default: var(--base00) !important;
        --control-primary-text-hover: var(--base00) !important;
        --control-primary-text-active: var(--base00) !important;
        --control-primary-icon-default: var(--base00) !important;
        --control-primary-icon-hover: var(--base00) !important;
        --control-primary-icon-active: var(--base00) !important;
        --badge-text-brand: var(--base00) !important;
        --checkbox-icon-active: var(--base00) !important;
        --radio-thumb-background-active: var(--base00) !important;
        --switch-thumb-background-selected-default: var(--base00) !important;
      }
      .visual-refresh path[fill^="rgba(88, 101, 242, 1)"] {
        fill: var(--base07) !important;
      }

      /* Components that hardcode white text on a brand background */
      .active_a19535,
      .activeButton_c15210,
      .botTagRegular__82f07,
      .calendarPicker_d27f17 .react-datepicker__day--selected,
      .calendarPicker_d27f17 .react-datepicker__day--keyboard-selected,
      .calendarPicker_d27f17 .react-datepicker__day:hover,
      .circleIconButton__5bc7e.selected__5bc7e,
      .discordIcon__1ad33,
      .executedCommand_c19a55 .appLauncherOnboardingCommandName_c19a55:hover,
      .giftCardIcon__43963,
      .guildIcon__4591d,
      .modeSelected__2ea32 .acronym__2ea32,
      .newBadge_edf232,
      .newMessagesBar__0f481,
      .newTopicsBarContainer__0f481,
      .noIcon__0a95c,
      .pill__4c084,
      .roleCheckmark_e59759,
      .selectedBrand_f975d3,
      .tierCloseHint_a36dee,
      .tierTrialIndicator__3efc4,
      .tooltipBrand_c36707,
      .wrapper__6e9f8.selected__6e9f8 .childWrapper__6e9f8,
      .wrapper__6e9f8:hover .childWrapper__6e9f8 {
        color: var(--base00) !important;
      }
      .wrapper__6e9f8.selected__6e9f8 .childWrapper__6e9f8 :is(svg, path),
      .wrapper__6e9f8:hover .childWrapper__6e9f8 :is(svg, path) {
        color: var(--base00) !important;
        fill: var(--base00) !important;
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
