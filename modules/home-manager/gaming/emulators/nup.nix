{pkgs, ...}: {
  # nup packs decrypted Switch 1/2 dumps (base, updates, DLC) into one compressed
  # container the emulators can read. Lives in ang3lo-nur; see pkgs/ang3lo-nur/pkgs/nup.
  home.packages = [pkgs.nup];
}
