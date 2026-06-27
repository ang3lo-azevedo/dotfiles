{
  device,
  ramSize,
  luksSizeGB ? null, # null = fill all remaining space after ESP (single-OS installs)
  windowsSizeGB ? null, # null = no Windows partition
  sharedDisk ? false, # add a shared NTFS partition occupying all space after Windows
}: let
  luksSize =
    if luksSizeGB != null
    then "${toString luksSizeGB}G"
    else "100%";
in {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions =
          {
            ESP = {
              priority = 1;
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            luks = {
              priority = 2;
              size = luksSize;
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
          }
          // (
            if windowsSizeGB != null
            then {
              windows = {
                priority = 3;
                size = "${toString windowsSizeGB}G";
                type = "EBD0A0A2-B9E5-4433-87C0-68B6B72699C7";
                content = {
                  type = "filesystem";
                  format = "ntfs";
                  mountpoint = "/mnt/windows";
                  mountOptions = ["uid=1000" "gid=100" "nofail"];
                };
              };
            }
            else {}
          )
          // (
            if sharedDisk
            then {
              shared = {
                priority = 100;
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ntfs";
                  mountpoint = "/mnt/shared";
                  mountOptions = ["uid=1000" "gid=100" "user" "exec" "umask=000" "nofail"];
                };
              };
            }
            else {}
          );
      };
    };

    # Alternative: mount root as tmpfs for true amnesia (ephemeral data never touches disk,
    # power off mid-session leaves no traces). 2G is a cap, not reserved upfront.
    # To switch: uncomment this block, remove /root subvolume below, remove the
    # rollback service in impermanence.nix, and re-run disko (requires reinstall).
    #
    # nodev."/" = {
    #   fsType = "tmpfs";
    #   mountOptions = ["defaults" "size=2G" "mode=755"];
    # };

    # LVM exists solely to carve out an encrypted swap LV alongside the root LV.
    # On a reinstall, this whole lvm_vg block can be dropped: replace the luks
    # content type with "btrfs" directly and add a /swap subvolume instead:
    #
    # content = {
    #   type = "btrfs";
    #   extraArgs = ["-f"];
    #   subvolumes = {
    #     "/swap" = {
    #       mountpoint = "/swap";
    #       swap.swapfile.size = "${toString ramSize}G";
    #       mountOptions = ["noatime"];
    #     };
    #     ... same subvolumes as below ...
    #   };
    # };
    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "${toString ramSize}G";
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
