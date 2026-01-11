{
  # Load AMD GPU drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable accelerated graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
