{lib, ...}: {
  # Fonts come from the stylix zed target.
  programs.zed-editor = {
    enable = true;

    themes.perfect-dark = import ./zed-perfect-dark.nix;

    # Zed counterparts of shared-extensions.nix. Languages Zed ships built in
    # (C/C++, Go, Python, Markdown) need no extension.
    extensions = [
      "nix"
      "material-icon-theme"
      "basher"
      "comment"
      "csv"
      "docker-compose"
      "dockerfile"
      "git-firefly"
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
      # mkForce: the stylix zed target sets its own base16 theme
      theme = lib.mkForce "Perfect Dark";
      icon_theme = "Material Icon Theme";

      project_panel.dock = "right";

      # window.controlsStyle = "hidden": niri draws no decorations of its own
      window_decorations = "server";

      # AI stays out of the way but reachable: predictions only on alt-\,
      # Claude from the agent panel. disable_ai would remove both.
      edit_predictions.provider = "copilot";
      show_edit_predictions = false;
      agent_servers.claude-acp = {
        type = "registry";
        default_config_options.mode = "auto";
      };
      agent.enable_feedback = false;
      agent.commit_message_model = {
        provider = "copilot_chat";
        model = "gpt-4.1";
      };
      title_bar = {
        show_sign_in = false;
        show_onboarding_banner = false;
      };

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
