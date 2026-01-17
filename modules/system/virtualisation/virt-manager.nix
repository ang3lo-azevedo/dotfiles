{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  programs.virt-manager.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  users.users.ang3lo.extraGroups = [ "libvirtd" "kvm"];

  environment.systemPackages = with pkgs; [ 
    dnsmasq
    pciutils
  ];
}