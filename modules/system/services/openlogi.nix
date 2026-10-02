{inputs, ...}: {
  # Built in pkgs/ang3lo-nur from the latest release tag, which nvfetcher tracks there:
  # main gets several commits a day and each one would be a full local rebuild.
  imports = [inputs.ang3lo-nur.nixosModules.openlogi];

  # Importing the upstream module (rather than adding the plain nixpkgs
  # package) also installs the udev rules the agent needs for /dev/uinput,
  # /dev/hidraw*, and the mouse's /dev/input/event* node.
  programs.openlogi = {
    enable = true;
    launchAtLogin = true;
  };
}
