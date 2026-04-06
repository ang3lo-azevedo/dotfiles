{ pkgs, ... }:
{
  # Load AMD GPU drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable accelerated graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable AMD OpenCL runtime via ROCm.
  hardware.amdgpu.opencl.enable = true;

  # Handy tools for validating ROCm/OpenCL after rebuild.
  environment.systemPackages = with pkgs; [
    clinfo
    rocmPackages.rocminfo
  ];

/*   # Handle eGPU hot-unplug gracefully
  boot.kernelParams = [
    # Allow ACPI hotplug to work properly
    "pci=pcie_bus_safe"
    # Enable runtime PM for PCIe devices (helps with eGPU hot-unplug)
    "amd_iommu=on"
  ];

  # Enable PCIe hotplug support
  boot.kernelModules = [ "pcie_hp" "acpihp" ]; */
}
