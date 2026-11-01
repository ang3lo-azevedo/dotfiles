{pkgs, ...}: {
  home.packages = with pkgs; [
    texliveFull
    ltex-ls-plus
  ];

  programs.vscode.profiles.default.userSettings = {
    "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}/bin/ltex-ls-plus";
  };

  home.file.".latexmkrc".text = ''
    # Use lualatex for better font support
    $pdflatex = 'lualatex %O %S';
    $pdf_mode = 1;
  '';
}
