{ pkgs, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
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
    ];
    windowManagerPatch = true;
  };
}
