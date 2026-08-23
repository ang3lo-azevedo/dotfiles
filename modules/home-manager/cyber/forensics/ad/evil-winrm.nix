{pkgs, ...}: {
  home.packages = with pkgs; [
    evil-winrm
  ];
}
