{ mango
, ...
}:
/*
  The `let` block below builds an attribute set suitable for
  `xdg.configFile` where each entry maps `mango/<file>.conf` to the
  corresponding source file in the repo. This keeps the module DRY when
  adding or removing Mango config files.
*/
let
  # Path (relative to this file) to the repo directory containing mango configs
  mangoDir = ../../../home/ang3lo/.config/mango;

  # Read directory entries and filter to only `.conf` files
  mangoFiles = builtins.attrNames (builtins.readDir mangoDir);
  confFiles = builtins.filter (f: builtins.match ".*\\.conf$" f != null) mangoFiles;

  # Convert the list of filenames into an attrs set of xdg.configFile entries
  mangoConfigAttrs = builtins.listToAttrs (map (f: { name = "mango/${f}"; value = { source = "${mangoDir}/${f}"; }; }) confFiles);
in
{
  imports = [
    mango.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;
    settings = builtins.readFile (mangoDir + "/config.conf");
  };

  xdg.configFile = mangoConfigAttrs;
}
