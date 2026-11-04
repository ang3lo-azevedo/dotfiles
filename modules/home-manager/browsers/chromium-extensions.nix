{
  pkgs,
  config,
  lib,
  excludeIds ? [],
}: let
  stylixTheme = import ./chrome-theme.nix {inherit pkgs config lib;};
  unpackCrx = import ./unpack-crx.nix {inherit pkgs;};
  unpackUrl = import ./unpack-url.nix {inherit pkgs;};

  # Dynamically read and parse the updated hashes.json
  hashesData = builtins.fromJSON (builtins.readFile ./extensions/hashes.json);

  # Grab all custom chromiumUrls from options, filtering out excluded ones
  customExts = builtins.filter (e: e.chromiumUrl != null && e.chromiumHash != null && !(builtins.elem e.chromeId excludeIds)) (builtins.attrValues config.my.browsers.extensions);
  customChromeIds = builtins.map (e: e.chromeId) customExts;

  # Filter out 404/empty payloads from Google, exclude those overridden by custom URLs, AND exclude excludeIds
  validChromeExts = builtins.filter (ext: ext.hash != "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73" && !(builtins.elem ext.id customChromeIds) && !(builtins.elem ext.id excludeIds)) (builtins.attrValues (builtins.mapAttrs (id: val: val // {inherit id;}) hashesData));

  # Extensions loaded via --load-extension are reinstalled on every browser
  # launch, so their onInstalled handlers fire each time and some of them open
  # onboarding tabs on every startup. Patch those tabs out.
  patchesById = {
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" = [./extensions/patches/darkreader-no-help-tab.patch];
    "mifafbjbnhpmhfkpeepbkbkjdlldenlm" = [./extensions/patches/twp-no-options-tab.patch];
  };

  # Build the dynamic list of fetch derivations
  chromeExtDrvs = builtins.map (ext:
    unpackCrx {
      inherit (ext) id hash;
      patches = patchesById.${ext.id} or [];
    })
  validChromeExts;

  customExtDrvs = builtins.map (e: let
    drv = unpackUrl {
      name = "ext-${e.chromeId}";
      url = e.chromiumUrl;
      hash = e.chromiumHash;
      patches = patchesById.${e.chromeId} or [];
    };
  in
    if e.chromiumSubfolder != null
    then "${drv}/${e.chromiumSubfolder}"
    else "${drv}")
  customExts;

  allExtensions = [stylixTheme] ++ chromeExtDrvs ++ customExtDrvs;
in "--load-extension=${builtins.concatStringsSep "," allExtensions}"
