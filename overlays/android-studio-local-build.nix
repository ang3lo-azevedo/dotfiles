# Force the Android Studio unwrapped derivation to build locally.
#
# Android Studio is unfree, so Hydra never caches it: every version bump has to
# be built somewhere. With distributed builds on (modules/system/nixbuild), Nix
# sends the "-unwrapped" step to the remote builder, which first uploads its
# ~1.5 GiB source tarball. That is minutes of upstream bandwidth for a step that
# only untars the tarball and runs wrapProgram, no compilation.
#
# The nixpkgs wrapper already sets preferLocalBuild, but the unwrapped derivation
# does not. It is built with the plain "stdenv", so spread a stdenv whose
# mkDerivation injects preferLocalBuild and requiredSystemFeatures = ["local"]
# to force the unpack to happen locally from the tarball we already hold.
#
# Substitution stays enabled (no allowSubstitutes = false): if nixbuild already has
# this version cached, pull that working build rather than rebuilding. This guards
# against a non-deterministic local rebuild diverging from the cached output, the
# failure mode that broke the buildFHSEnv rootfs packages (see appimage-local-build).
_: prev: {
  android-studio = prev.android-studio.override {
    stdenv =
      prev.stdenv
      // {
        mkDerivation = args:
          prev.stdenv.mkDerivation (
            args
            // {
              preferLocalBuild = true;
              requiredSystemFeatures = (args.requiredSystemFeatures or []) ++ ["local"];
            }
          );
      };
  };
}
