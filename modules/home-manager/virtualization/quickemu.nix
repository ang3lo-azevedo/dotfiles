{
  config,
  lib,
  pkgs,
  ...
}: let
  vmDir = "${config.home.homeDirectory}/vms";

  # Paths are absolute so the VMs start from any directory, not only from vmDir.
  mkVmConf = name: extra: ''
    #!${pkgs.quickemu}/bin/quickemu --vm
    disk_img="${vmDir}/${name}/disk.qcow2"
    ${extra}
  '';

  vms = {
    # quickget names the ISO after the Kali release, so pick up whichever one it downloaded
    # kali-current = ''
    #   guest_os="linux"
    #   isos=(${vmDir}/kali-current/kali-linux-*-installer-amd64.iso)
    #   iso="''${isos[-1]}"
    #   disk_size="64G"
    #   cpu_cores="4"
    #   ram="8G"
    #   reverse shell listeners reachable from the guest's NAT side
    #   port_forwards=("4444:4444" "9001:9001")
    # '';

    # Reuses the installer and unattended setup that `quickget windows 11` left in windows-11
    windows-forensics = ''
      guest_os="windows"
      iso="${vmDir}/windows-11/windows-11.iso"
      # quickget's own virtio-win download gets replaced by a bot-check page
      fixed_iso="${pkgs.virtio-win.src}"
      # large enough to hold evidence images next to the tooling
      disk_size="128G"
      cpu_cores="4"
      ram="8G"
      tpm="on"
      secureboot="off"
    '';
  };
in {
  home.packages = [pkgs.quickemu];

  # quickget skips writing a conf that already exists, so it only fetches the ISO
  # and keeps the settings declared here.
  home.file =
    lib.mapAttrs' (name: extra:
      lib.nameValuePair "vms/${name}.conf" {
        text = mkVmConf name extra;
        executable = true;
      })
    vms
    // {
      # quickemu only attaches the unattended ISO when it sits next to the disk image
      "vms/windows-forensics/unattended.iso".source =
        config.lib.file.mkOutOfStoreSymlink "${vmDir}/windows-11/unattended.iso";
    };
}
