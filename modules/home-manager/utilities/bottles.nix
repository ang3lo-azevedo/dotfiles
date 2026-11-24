{pkgs, ...}: let
  bottles-unwrapped = let
    unwrapped =
      (pkgs.bottles-unwrapped.override {
        removeWarningPopup = true;
      }).overrideAttrs
      (_: {
        preferLocalBuild = true;
      });
  in
    unwrapped
    // {
      override = args:
        (pkgs.bottles-unwrapped.override (
          args
          // {
            removeWarningPopup = true;
          }
        )).overrideAttrs
        (_: {
          preferLocalBuild = true;
        });
    };

  bottles =
    (pkgs.bottles.override {
      inherit bottles-unwrapped;
      removeWarningPopup = true;
    }).overrideAttrs
    (_: {
      preferLocalBuild = true;
    });
in {
  # proxy.usebottles.com is down and the fallback sources are pinned to commits that predate
  # the experimental soda runners, the Microsoft 365 installers and their office-runtime/selawik deps
  home.packages = [
    (pkgs.symlinkJoin {
      name = "bottles-${bottles.version}";
      paths = [bottles];
      preferLocalBuild = true;
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
