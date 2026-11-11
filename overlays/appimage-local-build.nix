# Force appimageTools AppImage extraction and buildFHSEnv rootfs to build locally.
#
# appimageTools packages pulled from nixpkgs (code-cursor and the like) fetch a
# large AppImage, then do nothing but untar it. With distributed builds on
# (modules/system/nixbuild), Nix routes that untar to the remote builder, which
# first has to upload the whole AppImage: minutes of upstream bandwidth for a step
# worth seconds locally, and the unfree ones are never in cache.nixos.org to pull
# from instead.
#
# Similarly, buildFHSEnv rootfs derivations (such as steam-fhsenv-rootfs) do
# nothing but create symlinks, but reference the entire closure of hundreds of
# packages. Offloading them to remote builders requires uploading all missing
# packages over SSH.
#
# By tagging these with `requiredSystemFeatures = ["local"]` (advertised only by
# the local host in nix.settings.system-features, not by eu.nixbuild.net), Nix is
# strictly prevented from dispatching them over SSH to remote builders even when
# local build slots are fully saturated.
_: prev: {
  appimageTools = prev.appimageTools.override {
    runCommand = name: env: cmd:
      prev.runCommand name (
        env
        // {
          preferLocalBuild = true;
          allowSubstitutes = false;
          requiredSystemFeatures = (env.requiredSystemFeatures or []) ++ ["local"];
        }
      )
      cmd;
  };

  buildFHSEnvBubblewrap = args:
    (prev.buildFHSEnvBubblewrap.override {
      callPackage = fn: a:
        prev.callPackage fn (
          a
          // {
            pkgs =
              prev
              // {
                runCommand = name: env: cmd:
                  prev.runCommand name (
                    env
                    // {
                      preferLocalBuild = true;
                      allowSubstitutes = false;
                      requiredSystemFeatures = (env.requiredSystemFeatures or []) ++ ["local"];
                    }
                  )
                  cmd;
              };
          }
        );
    })
    args
    // {
      requiredSystemFeatures = ["local"];
    };
}
