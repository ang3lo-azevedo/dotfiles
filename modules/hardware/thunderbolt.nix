{
  # Thunderbolt security daemon, manages authorization for new/unknown devices.
  # Known devices are authorized declaratively by udev rules below.
  # Unknown devices still require manual approval via boltctl.
  services.hardware.bolt.enable = true;

  services.udev.extraRules = ''
    # Authorize known trusted Thunderbolt devices by UUID. IOMMU isolation is
    # still enforced by the kernel regardless of how authorization happens.
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{unique_id}=="105a4c17-c0ca-79fd-ffff-ffffffffffff", ATTR{authorized}="1"
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{unique_id}=="c2010000-0082-841e-033a-d28df030ca02", ATTR{authorized}="1"

    # After authorization, trigger a PCIe rescan so the eGPU driver binds
    # without needing a hot-replug.
    ACTION=="change", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="1", RUN+="/bin/sh -c 'echo 1 > /sys/bus/pci/rescan'"
  '';
}
