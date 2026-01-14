{
  # Enable Thunderbolt daemon
  services.hardware.bolt.enable = true;

  # Improve Thunderbolt device handling during hot-unplug
  boot.kernelParams = [
    # Enable ACPI hotplug
    "acpi_osi=Linux"
    # Set PCIe AER to not fatal for better error handling during disconnect
    "pcie_ports=compat"
  ];

  # Ensure proper timeout handling for device removal
  environment.etc."modprobe.d/thunderbolt.conf".text = ''
    # Allow more time for device shutdown during hot-unplug
    options thunderbolt delay_fi=100
  '';
}