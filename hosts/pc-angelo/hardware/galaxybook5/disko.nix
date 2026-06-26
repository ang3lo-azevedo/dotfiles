let
  mainDiskSize = 500; # In GB
  ramSize = 32; # In GB
  device = "/dev/nvme0n1";
in {
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
            size = toString (mainDiskSize / 2) + "G"; # 50% of mainDiskSize
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
          windows = {
            priority = 3;
            size = toString ((mainDiskSize / 2) / 4) + "G"; # 25% of 50% of mainDiskSize
            type = "EBD0A0A2-B9E5-4433-87C0-68B6B72699C7"; # Windows Basic Data Partition GUID
            content = {
              type = "filesystem";
              format = "ntfs";
              mountpoint = "/mnt/windows";
              mountOptions = [
                "uid=1000"
                "gid=100"
                "nofail"
              ];
            };
          };
          shared = {
            priority = 100; # Highest number = lowest priority = created last, placed at end of disk
            size = "100%"; # Use all remaining space
            content = {
              type = "filesystem";
              format = "ntfs";
              mountpoint = "/mnt/shared";
              mountOptions = [
                "uid=1000"
                "gid=100"
                "user"
                "exec" # Allows Linux to launch the games
                "umask=000"
                "nofail"
              ];
            };
          };
        };
      };
    };

    # Alternative: mount root as tmpfs for true amnesia (ephemeral data never touches disk,
    # power off mid-session leaves no traces). 2G is a cap, not reserved upfront: actual
    # usage is typically ~200MB with 32GB RAM having no meaningful impact on gaming.
    # To switch: uncomment this block, remove the /root subvolume below, remove the
    # rollback service in impermanence.nix, and re-run disko (requires reinstall).
    #
    # nodev."/" = {
    #   fsType = "tmpfs";
    #   mountOptions = ["defaults" "size=2G" "mode=755"];
    # };

    # LVM Volume Group and Logical Volumes
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = toString ramSize + "G";
          content = {
            type = "swap";
          };
        };
        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = ["compress=zstd:3" "noatime" "discard=async"];
              };
              "/persist" = {
                mountpoint = "/persist";
                mountOptions = ["compress=zstd:3" "noatime" "discard=async"];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = ["compress=zstd:1" "noatime" "discard=async"];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = ["compress=zstd:3" "noatime" "discard=async"];
              };
            };
          };
        };
      };
    };
  };
}
