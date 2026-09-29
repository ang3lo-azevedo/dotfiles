{pkgs, ...}: let
  # Office 365 installer (bottlesdevs/programs#500) needs success_codes/skip_if_files_exist support, newer than the 67.4 release
  bottles-unwrapped = pkgs.bottles-unwrapped.overrideAttrs (_: {
    version = "67.4-unstable-2026-09-29";
    src = pkgs.fetchFromGitHub {
      owner = "bottlesdevs";
      repo = "bottles";
      rev = "44651052435c57fd4d0acb682d6490edadbcd52d";
      hash = "sha256-8mqBlyo0l4Iv/3YD2QOlfpBJhGPNRch3h8w4yW5M2yM=";
    };
  });

  bottles = pkgs.bottles.override {
    inherit bottles-unwrapped;
    removeWarningPopup = true;
  };
in {
  # proxy.usebottles.com is down and the fallback sources are pinned to commits that predate
  # the experimental soda runners, the Microsoft 365 installers and their office-runtime/selawik deps
  home.packages = [
    (pkgs.symlinkJoin {
      name = "bottles-${bottles.version}";
      paths = [bottles];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        for bin in bottles bottles-cli; do
          wrapProgram $out/bin/$bin \
            --set-default PERSONAL_COMPONENTS https://raw.githubusercontent.com/bottlesdevs/components/main/ \
            --set-default PERSONAL_DEPENDENCIES https://raw.githubusercontent.com/bottlesdevs/dependencies/main/ \
            --set-default PERSONAL_INSTALLERS https://raw.githubusercontent.com/bottlesdevs/programs/main/
        done
      '';
    })
  ];
}
