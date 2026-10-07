{pkgs, ...}: {
  home.packages = with pkgs; [
    # plain libguestfs ships without the boot appliance its tools need
    libguestfs-with-appliance
  ];
}
