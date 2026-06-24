{pkgs, ...}: {
  home.packages = with pkgs; [
    pdfcrack
  ];
}
