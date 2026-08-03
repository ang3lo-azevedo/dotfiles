{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    pdfcrack
  ];
}
