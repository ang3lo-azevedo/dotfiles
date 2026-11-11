{pkgs, ...}: {
  # VR CyberDeck: multi-OS sideloader for Android and Meta Quest devices.
  # Provides APK/OBB sideloading, wireless/USB ADB tweaks, and browsable
  # remote libraries. See pkgs/ang3lo-nur/pkgs/vrcd.
  home.packages = [pkgs.vrcd];
}
