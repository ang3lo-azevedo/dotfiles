{ lib, device ? "/dev/sda", ... }:

{
  options.myDisko = {
    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      description = "The block device to partition.";
    };
  };

  config = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = config.myDisko.device;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg = "pool";
                  };
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        pool = {
          type = "lvm_vg";
          lvs = {
            # Dedicated Swap for stable Hibernation
            swap = {
              size = "32G"; # Set this to match your RAM for Hibernation
              content = {
                type = "swap";
              };
            };
            # Btrfs Root
            root = {
              size = "100%FREE";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing data
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
