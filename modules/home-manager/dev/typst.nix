{pkgs, ...}: let
  openPdfTask = "typst: open pdf";
in {
  home.packages = with pkgs; [
    typst
    tinymist # standard typst LSP
  ];

  # Reloads on its own whenever tinymist rewrites the PDF.
  programs.zathura.enable = true;

  programs.zed-editor = {
    userSettings.lsp.tinymist = {
      binary.path = "tinymist";
      # autosave makes onSave fire about a second after the last keystroke
      settings.exportPdf = "onSave";
    };

    userTasks = [
      {
        label = openPdfTask;
        command = "zathura";
        args = ["--fork" "$ZED_DIRNAME/$ZED_STEM.pdf"];
        reveal = "never";
        hide = "always";
      }
    ];

    userKeymaps = [
      {
        context = "Editor && extension == typ";
        bindings.ctrl-alt-p = ["task::Spawn" {task_name = openPdfTask;}];
      }
    ];
  };
}
