{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  # Wipe /root subvolume on every boot before it is mounted.
  # Using script (not ExecStart) so the initrd module handles the path automatically.
  # path includes btrfs-progs so the btrfs binary is available in the initrd.
  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a clean state";
    wantedBy = ["initrd.target"];
    after = ["dev-pool-root.device"];
    before = ["sysroot.mount"];
    path = [pkgs.btrfs-progs];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /btrfs_tmp
      mount -t btrfs /dev/pool/root /btrfs_tmp
      if [ -e /btrfs_tmp/root ]; then
        btrfs subvolume delete /btrfs_tmp/root
      fi
      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

  # Fix permissions of /var/lib/private after impermanence bind-mounts
  systemd.services."systemd-tmpfiles-resetup" = {
    serviceConfig.RemainAfterExit = lib.mkForce false;
  };

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
      "/var/lib/fprint"
      "/var/lib/sbctl"
      "/etc/ssh"
      "/var/lib/boltd"
      "/var/lib/nordvpn"
      "/var/lib/containers"
      "/var/lib/libvirt"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
