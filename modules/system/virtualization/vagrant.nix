{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vagrant
  ];
}
