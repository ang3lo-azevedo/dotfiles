{pkgs, ...}: {
  my.browsers.extensions.violentmonkey = {
    firefoxPackage = pkgs.firefoxAddons.violentmonkey;
    chromeId = "jinjaccalenkbemacfhnhbhgiignbcca";
    chromiumUrl = "https://github.com/violentmonkey/violentmonkey/releases/download/v2.49.0/Violentmonkey-mv3-v2.49.0.zip";
    chromiumHash = "1vpq45crbhj3bkjrasigqnza8adwsjbf9pr3xm9q8sd90g47d9iz";
  };
}
