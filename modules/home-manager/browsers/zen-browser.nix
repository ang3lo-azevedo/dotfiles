{ inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser.enable = true;

  programs.zen-browser.profiles = lib.attrsets.mapAttrs (name: value: {
    extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
      adnauseam
      violentmonkey
      darkreader
      bitwarden
      #TorBox Control missing
      duckduckgo-privacy-essentials
      wayback-machine
      user-agent-string-switcher
      # Faster Pageload missing
      # Translate this page missing
      foxyproxy-standard
      clearurls
      # NopeCHA missing
    ];
  }) {
    # This will apply the extensions to a profile named "default"
    # and any other profiles you might define here.
    default = {};
  };
}
