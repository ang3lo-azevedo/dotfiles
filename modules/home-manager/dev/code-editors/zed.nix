_: {
  # Theme and fonts come from the stylix zed target.
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "material-icon-theme"
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
