{pkgs, ...}: {
  # Load AMD GPU drivers
  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  # Enable AMD OpenCL runtime via ROCm.
  hardware.amdgpu.opencl.enable = true;

  # Handy tools for validating ROCm/OpenCL after rebuild.
  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages.rocminfo
  ];

  # Reallocate PCI bridge windows at boot so the eGPU's large BAR (16GB on
  # the Navi 44) always gets an address range, even when the BIOS sized the
  # Thunderbolt bridge windows too small. Without this the BAR assignment
  # fails intermittently across boots.
  boot.kernelParams = ["pci=realloc=on"];

  /*
     # Handle eGPU hot-unplug gracefully
  boot.kernelParams = [
    # Allow ACPI hotplug to work properly
    "pci=pcie_bus_safe"
    # Enable runtime PM for PCIe devices (helps with eGPU hot-unplug)
    "amd_iommu=on"
  ];

  # Enable PCIe hotplug support
  boot.kernelModules = [ "pcie_hp" "acpihp" ];
  */
}
