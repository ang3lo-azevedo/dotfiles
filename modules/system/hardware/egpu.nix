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

  # Enable OpenCL and other compute frameworks
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  
  # Tools for managing eGPU
  environment.systemPackages = with pkgs; [
    bolt
    pciutils
    radeontop
  ];
}
