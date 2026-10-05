_: {
  # Theme and fonts come from the stylix zed target.
  programs.zed-editor = {
    enable = true;

    # Installed but inactive: to switch, add `lib` to the module arguments and
    # set userSettings.theme = lib.mkForce "Perfect Dark".
    themes.perfect-dark = import ./zed-perfect-dark.nix;

    # Zed counterparts of shared-extensions.nix. Languages Zed ships built in
    # (C/C++, Go, Python, Markdown) need no extension.
    extensions = [
      "nix"
      "material-icon-theme"
      "basher"
      "csv"
      "docker-compose"
      "dockerfile"
      "github-actions"
      "groovy"
      "html"
      "java"
      "kdl"
      "kotlin"
      "latex"
      "log"
      "ltex"
      "make"
      "neocmake"
      "powershell"
      "rainbow-csv"
      "sql"
      "toml"
      "typst"
    ];

    # explorer.confirmDelete = false
    userKeymaps = [
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          delete = ["project_panel::Trash" {skip_prompt = true;}];
          backspace = ["project_panel::Trash" {skip_prompt = true;}];
        };
      }
    ];

    userSettings = {
      # Managed by Nix
      auto_update = false;

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      autosave.after_delay.milliseconds = 1000;
      relative_line_numbers = "enabled";
      icon_theme = "Material Icon Theme";

      project_panel.dock = "right";

      # window.controlsStyle = "hidden": niri draws no decorations of its own
      window_decorations = "server";

      edit_predictions.provider = "copilot";

      languages.Nix = {
        language_servers = ["nil" "!nixd"];
        format_on_save = "on";
      };

      lsp.nil = {
        binary.path = "nil";
        settings.formatting.command = ["nixfmt"];
      };
    };
  };
}
