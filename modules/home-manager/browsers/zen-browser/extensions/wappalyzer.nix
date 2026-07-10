{
  pkgs,
  profileName,
  ...
}: {
  programs.zen-browser.profiles.${profileName}.extensions.packages = [
    (pkgs.buildFirefoxXpiAddon {
      pname = "wappalyzer";
      version = "6.12.4";
      addonId = "wappalyzer@crunchlabz.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4887810/wappalyzer-6.12.4.xpi";
      sha256 = "1yppiiw539d5k4wcgkw9rnxhdpqnp0z2x9wkrrqky5dwylkam60i";
      meta = {};
    })
  ];
}
