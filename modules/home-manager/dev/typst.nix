{
  lib,
  pkgs,
  ...
}: let
  openPdfTask = "typst: open pdf";
  livePreviewTask = "typst: live preview";
in {
  home.packages = with pkgs; [
    typst
    tinymist # standard typst LSP & preview engine
    websocat # websocket bridge for preview tools
  ];

  # Reloads on its own whenever tinymist rewrites the PDF.
  programs.zathura = {
    enable = true;
    options = {
      # Automatically copy selected text directly to the system clipboard (Ctrl+V)
      # instead of only the X11/Wayland primary selection
      selection-clipboard = "clipboard";
    };
  };

  # mkBefore: the browser module also claims PDFs and the first entry wins
  xdg.mimeApps.defaultApplications."application/pdf" = lib.mkBefore ["org.pwmt.zathura.desktop"];

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
        args = [
          "--fork"
          "$ZED_DIRNAME/$ZED_STEM.pdf"
        ];
        reveal = "never";
        hide = "always";
      }
      {
        label = livePreviewTask;
        command = "tinymist";
        args = [
          "preview"
          "$ZED_FILE"
          "--open"
        ];
        reveal = "never";
        hide = "always";
      }
    ];

    userKeymaps = [
      {
        context = "Editor && extension == typ";
        bindings = {
          "ctrl-alt-p" = [
            "task::Spawn"
            {task_name = openPdfTask;}
          ];
          "ctrl-alt-l" = [
            "task::Spawn"
            {task_name = livePreviewTask;}
          ];
        };
      }
    ];
  };
}
