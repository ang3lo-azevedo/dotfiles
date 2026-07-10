# TODO: remove doInstallCheck override once upstream vagrant fixes its installCheckPhase
{pkgs, ...}: {
  environment.systemPackages = [
    # doInstallCheck = false alone is not enough for bundlerEnv ruby gems: the
    # phase script still runs. Nulling out the scripts is the only reliable way.
    (pkgs.vagrant.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
      checkPhase = "";
      installCheckPhase = "";
    }))
  ];
}
