{inputs, ...}: {
  imports = [inputs.horizon.nixosModules.default];

  # programs.horizon installs the launcher (patched to run natively, no FHS) and
  # adds the game's runtime libraries to nix-ld (Vulkan, Wayland, X11, udev, ALSA,
  # Java libs). Chosen over an FHS/AppImage wrap so native-mod builds work: the
  # launcher runs in the real session, so its "run nix-shell in the launcher
  # folder, then build" flow for native mods behaves like a normal native compile.
  # nix-ld is already enabled in pc.nix; this merges extra libraries into it.
  programs.horizon.enable = true;
}
