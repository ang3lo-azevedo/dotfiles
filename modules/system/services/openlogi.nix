{
  inputs,
  pkgs,
  ...
}: {
  # Built in pkgs/ang3lo-nur from the latest release tag, which nvfetcher tracks there:
  # main gets several commits a day and each one would be a full local rebuild.
  imports = [inputs.ang3lo-nur.nixosModules.openlogi];

  # Importing the upstream module (rather than adding the plain nixpkgs
  # package) also installs the udev rules the agent needs for /dev/uinput,
  # /dev/hidraw*, and the mouse's /dev/input/event* node.
  programs.openlogi = {
    enable = true;
    launchAtLogin = true;

    # For now use the nixpkgs build instead of the NUR source build: openlogi is
    # a GPUI/Rust workspace whose local compile is heavy, and cache.nixos.org
    # already has the nixpkgs binary, so this substitutes instead of building.
    # The NUR module stays imported for its udev rules and agent user service;
    # only the package is swapped. Trade-off: nixpkgs lags the NUR release
    # (0.6.25 vs 0.9.0), so remove this line to go back to the latest from source.
    package = pkgs.openlogi;
  };
}
