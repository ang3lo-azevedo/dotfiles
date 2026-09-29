{pkgs, ...}: let
  # Office 365 support (bottlesdevs/programs#500) needs at least this commit, newer than the 67.4 release
  bottles-unwrapped = pkgs.bottles-unwrapped.overrideAttrs (_: {
    version = "67.4-unstable-2026-09-20";
    src = pkgs.fetchFromGitHub {
      owner = "bottlesdevs";
      repo = "bottles";
      rev = "5cbb5be22795fc877cab063dc2e7066618f8a5d4";
      hash = "sha256-Oc7HXfgTro4K7FfFsLvSjK+oBFxlTFKeMB1J1htY4uU=";
    };
  });

  bottles = pkgs.bottles.override {
    inherit bottles-unwrapped;
    removeWarningPopup = true;
  };
in {
  # proxy.usebottles.com is down and the fallback source is pinned to a components commit
  # that predates the experimental soda runners, so track upstream main instead
  home.packages = [
    (pkgs.symlinkJoin {
      name = "bottles-${bottles.version}";
      paths = [bottles];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        for bin in bottles bottles-cli; do
          wrapProgram $out/bin/$bin \
            --set-default PERSONAL_COMPONENTS https://raw.githubusercontent.com/bottlesdevs/components/main/
        done
      '';
    })
  ];
}
