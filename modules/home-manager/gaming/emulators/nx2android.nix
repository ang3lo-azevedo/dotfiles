{pkgs, ...}: {
  # nx2android ports your own Switch games to Android: the GUI (nx2android) and
  # the command-line porter (nx2android-porter). Lives in ang3lo-nur; see
  # pkgs/ang3lo-nur/pkgs/nx2android. It downloads the Android NDK, .NET SDK and
  # platform-tools into ~/.config/nx2android on first use.
  home.packages = [pkgs.nx2android];
}
