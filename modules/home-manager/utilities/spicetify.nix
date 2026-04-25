{ pkgs, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  # TODO: Temporary fix for playback issue. Remove this override when fixed at source.
  # Latest Spotify build currently published for Linux via Snapcraft.
  spotifyLatestLinux = pkgs.spotify.overrideAttrs (_: rec {
    version = "1.2.86.502.g8cd7fb22";
    src = pkgs.fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_94.snap";
      hash = "sha256-XhwyaObck6viIvDRXEztlSLja5fsfw5HgHUUQzMehLI=";
    };
  });
in
{
  imports = [
    spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    spotifyPackage = spotifyLatestLinux;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      volumePercentage
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
