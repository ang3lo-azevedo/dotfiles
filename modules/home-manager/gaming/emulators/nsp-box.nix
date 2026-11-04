{pkgs, ...}: {
  # NSP Box packages lawfully obtained Switch 2 game snapshots and extracted DLC
  # into .nsp containers. Lives in ang3lo-nur; see pkgs/ang3lo-nur/pkgs/nsp-box.
  home.packages = [pkgs.nsp-box];
}
