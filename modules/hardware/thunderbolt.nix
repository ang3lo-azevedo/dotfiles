{pkgs, ...}: {
  # Thunderbolt security daemon, manages authorization. Unknown devices require
  # manual approval via boltctl. Known devices are enrolled in its database.
  services.hardware.bolt.enable = true;

  # After bolt authorizes a Thunderbolt device, trigger a PCIe rescan so the
  # eGPU driver binds without needing a hot-replug.
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="1", RUN+="${pkgs.bash}/bin/sh -c 'echo 1 > /sys/bus/pci/rescan'"
  '';

  # The eGPU enclosure powers up slowly and may not enumerate on the Thunderbolt
  # bus in time for the boot-time scan. This service rescans PCIe a few seconds
  # after the graphical session starts to catch late-powering devices.
  systemd.services.egpu-rescan = {
    description = "Delayed PCIe rescan for eGPU boot initialization";
    after = ["graphical.target"];
    wantedBy = ["graphical.target"];
    script = ''
      ${pkgs.coreutils}/bin/sleep 5
      echo 1 > /sys/bus/pci/rescan
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
