{pkgs, ...}: {
  home.packages = with pkgs; [
    typst
    tinymist # standard typst LSP
  ];
}
