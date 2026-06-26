{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  # Wipe /root subvolume on every boot before it is mounted
  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a clean state";
    wantedBy = ["initrd.target"];
    after = ["dev-pool-root.device"];
    before = ["sysroot.mount"];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "rollback" ''
        mkdir /btrfs_tmp
        mount -t btrfs /dev/pool/root /btrfs_tmp
        if [ -e /btrfs_tmp/root ]; then
          btrfs subvolume delete /btrfs_tmp/root
        fi
        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };
  };

  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
      "/var/lib/fprint"
      "/var/lib/sbctl"
      "/var/lib/systemd/pcrlock.d"
      "/etc/ssh"
      "/var/lib/boltd"
      "/var/lib/dnscrypt-proxy"
      "/var/lib/nordvpn"
      "/var/lib/containers"
      "/var/lib/libvirt"
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/systemd/pcrlock.json"
      "/var/lib/systemd/random-seed"
      "/var/lib/systemd/credential.secret"
      "/var/lib/systemd/tpm2-srk-public-key.pem"
      "/var/lib/systemd/tpm2-srk-public-key.tpm2b_public"
    ];
  };
}
