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

    # Use the cached nixpkgs build instead of the NUR source build: openlogi is a
    # GPUI/Rust workspace whose compile is heavy, and cache.nixos.org already has
    # the nixpkgs binary. Plain `pkgs.openlogi` does not work here: the ang3lo-nur
    # overlay shadows it with the NUR's own source build (0.9.0), so reach past the
    # overlay to the nixpkgs package. nixpkgs ships 0.6.25, older than the NUR's
    # 0.9.0: that version gap is the trade for not building from source. The NUR
    # module stays imported for its udev rules and agent user service (its import
    # still fetches the upstream source at eval; swapping the package does not
    # change that).
    package = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.openlogi;
  };
}
