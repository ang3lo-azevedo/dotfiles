{inputs, ...}: {
  imports = [inputs.openlogi.nixosModules.default];

  # Importing the upstream module (rather than adding the plain nixpkgs
  # package) also installs the udev rules the agent needs for /dev/uinput,
  # /dev/hidraw*, and the mouse's /dev/input/event* node.
  programs.openlogi = {
    enable = true;
    launchAtLogin = true;
  };
}
