# Keep appimageTools AppImage extraction off the eu.nixbuild.net remote builder.
#
# appimageTools packages (code-cursor and the like) fetch a large AppImage, then do
# nothing but unsquashfs it. With distributed builds on (modules/system/nixbuild),
# Nix can route that extraction to the remote builder, which first has to upload the
# whole AppImage over this machine's slow uplink: minutes of bandwidth for work worth
# seconds locally, and the unfree ones are never in cache.nixos.org to pull from.
#
# Tagging with requiredSystemFeatures = ["local"] (advertised only by the local host
# in nix.settings.system-features, never by eu.nixbuild.net) keeps the extraction on
# this machine. Substitution stays enabled, so a build already cached on nixbuild is
# still pulled rather than re-extracted.
#
# NOTE: this deliberately does NOT touch buildFHSEnv/buildFHSEnvBubblewrap. Those
# rootfs derivations are non-deterministic (the symlink farm and glib schema
# compilation differ between hosts); forcing them to build locally instead of being
# substituted from nixbuild produces a broken rootfs where the dynamic linker cannot
# resolve libraries that are physically present (observed with zoom-us: ZoomLauncher
# failing on libglib-2.0.so.0). FHS packages must come from nixbuild or its cache.
_: prev: {
  appimageTools = prev.appimageTools.override {
    runCommand = name: env: cmd:
      prev.runCommand name (
        env
        // {
          preferLocalBuild = true;
          requiredSystemFeatures = (env.requiredSystemFeatures or []) ++ ["local"];
        }
      )
      cmd;
  };
}
