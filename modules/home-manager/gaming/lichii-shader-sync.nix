{pkgs, ...}: {
  # lichii-shader-sync: CLI that downloads shared Vulkan shader caches into the
  # Lichii/Eden shader folder to cut first-play stutter. Run `lichii-sync sync`
  # (with the emulators closed). See pkgs/ang3lo-nur/pkgs/lichii-shader-sync.
  home.packages = [pkgs.lichii-shader-sync];
}
