{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    discord = {
      vencord.enable = false;
      equicord.enable = true;
      # TODO: Temporary workaround for FlameFlag/nixcord Equicord pnpmDepsHash mismatch (issue #182).
      # Remove this override once upstream updates pkgs/equicord.nix with the correct hash.
      equicord.package =
        inputs.nixcord.packages.${pkgs.stdenv.hostPlatform.system}.equicord.overrideAttrs
          (oldAttrs:
            let
              remoteParts = pkgs.lib.splitString "/" oldAttrs.env.EQUICORD_REMOTE;
              owner = builtins.elemAt remoteParts 0;
              repo = builtins.elemAt remoteParts 1;
              version = oldAttrs.version;
              src = pkgs.fetchFromGitHub {
                inherit owner repo;
                tag = version;
                hash = "sha256-aR+FVoevgPatWU/WqAcASqU5+c1ixNS9iSvkWbyAZr4=";
                leaveDotGit = true;
              };
            in
            {
              inherit src;
              pnpmDeps = pkgs.fetchPnpmDeps {
                inherit src version;
                inherit (oldAttrs) pname;
                inherit (oldAttrs.pnpmDeps) pnpm fetcherVersion;
                hash = "sha256-7YkB7KO96UUeVAk5VwxGcAhHYDTue7gj0nk/gxs3BmI=";
              };
            });
    };
    config = {
      autoUpdate = true;
      plugins = {
        fakeNitro.enable = true;
        noNitroUpsell.enable = true;
        questify = {
          enable = true;
          completeAchievementQuestsInBackground = true;
          completeGameQuestsInBackground = true;
          completeVideoQuestsInBackground = true;
        };
        spotifyActivityToggle.enable = true;
        spotifyCrack = {
          enable = true;
          noSpotifyAutoPause = false;
        };
        musicControls.enable = true;
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
