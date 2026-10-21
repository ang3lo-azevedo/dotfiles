{
  pkgs,
  spicetify-nix,
  ...
}: let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      volumePercentage
      # Waveform as the playback bar, from Spotify's internal audio-analysis endpoint
      # (the public one is gone since 2025). The built file carries its own CSS.
      # Pinned: it runs inside the logged-in client
      {
        src = "${pkgs.fetchFromGitHub {
          owner = "Konsl";
          repo = "spicetify-extensions";
          rev = "db60731ca9b31adf55c50ff64c83bb2f13d87765";
          hash = "sha256-H24gqwvrWC+D+RQ+xdsU0JtGt/+cmlk1IV/ru2LOGnk=";
        }}/playback-bar-waveform/dist";
        name = "playback-bar-waveform.js";
      }
    ];
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];
    enabledSnippets = with spicePkgs.snippets; [
      smoothProgressBar
      smallVideoButton
      queueTopSidePanel
      smallerRightSidebarCover
      hideDownloadButton
      thinLibrarySidebarRows
      modernScrollbar
      roundedNowPlaying
      roundedImages
      removeTopSpacing
      dynamicLeftSidebar
      fixMainViewWidth
      removeTheArtistsAndCreditsSectionsFromTheSidebar

      # Remove Unused Space in Topbar
      ''
        .Kgjmt7IX5samBYUpbkBu, .OPsY6bKl1_FfA8jFpq1V { display: none !important; }
      ''

      # Remove Top gradient
      ''
        .main-entityHeader-backgroundColor { display: none !important; } .main-actionBarBackground-background { display: none !important; } .main-home-homeHeader { display: none !important; } .playlist-playlist-actionBarBackground-background { display: none !important; }
      ''
    ];
    windowManagerPatch = true;
  };
}
