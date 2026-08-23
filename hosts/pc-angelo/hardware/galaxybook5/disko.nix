import ../../../../modules/system/disko.nix {
  device = "/dev/disk/by-id/nvme-SSSTC_CL4-8D512_0024434003K7";
  ramSize = 32;
  luksSizeGB = 250; # 50% of 500 GB disk
}
