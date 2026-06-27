import ../../../../modules/system/disko.nix {
  device = "/dev/nvme0n1";
  ramSize = 32;
  luksSizeGB = 250; # 50% of 500 GB disk
  windowsSizeGB = 62; # 25% of the Linux half (500 / 2 / 4)
  sharedDisk = true;
}
