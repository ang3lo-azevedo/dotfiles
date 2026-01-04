{ pkgs, ... }:

{
  # Enable Thunderbolt daemon
  services.hardware.bolt.enable = true;

  # Load AMD GPU drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

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
