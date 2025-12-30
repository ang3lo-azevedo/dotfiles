{ device ? "/dev/nvme0n1"
, ...
}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "umask=0077"
              ];
            };
          };
          luks = {
            priority = 2;
            size = "50%FREE";
            content = {
              type = "luks";
              name = "cryptroot";
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
          # Windows partition space
          windows_space = {
            priority = 3;
            size = "25%FREE";
            # Leave unformatted for Windows installation
          };
          shared_games = {
            priority = 100; # High number priority to be on the end of the disk
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ntfs";
              mountpoint = "/mnt/shared_games";
              mountOptions = [ 
                "uid=1000" 
                "gid=100" 
                "rw" 
                "user" 
                "exec" # Allows Linux to launch the games
                "umask=000" 
                "nofail" 
                "windows_names" # Prevents Linux from creating files Windows can't read
              ];
            };
          };
        };
      };
    };

    # Mount Windows partition
    # TODO: Enable after Windows installation
    /*
    nodev."windows_mount" = {
      mountpoint = "/mnt/windows";
      device = "${device}p3";
      fsType = "ntfs-3g";
      mountOptions = [ 
        "rw"
        "uid=1000"
        "gid=100"
        "nofail" 
        "windows_names"
      ];
    };
    */

    # LVM Volume Group and Logical Volumes
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "32G";
          content = {
            type = "swap";
          };
        };
        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" ];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
