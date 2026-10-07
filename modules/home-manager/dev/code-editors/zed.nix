{
  lib,
  pkgs,
  ...
}: let
  commit-msg = pkgs.writeShellApplication {
    name = "zed-commit-msg";
    runtimeInputs = [pkgs.git pkgs.wl-clipboard];
    text = ''
      diff=$(git diff --cached)
      [[ -n $diff ]] || diff=$(git diff HEAD)
      if [[ -z $diff ]]; then
        echo "no changes to describe" >&2
        exit 1
      fi

      {
        echo "Recent subjects:"
        git log -10 --format=%s
        echo
        echo "Status:"
        git status --short
        echo
        echo "Diff:"
        head -c 100000 <<<"$diff"
      } | claude -p --model haiku --tools "" --no-session-persistence \
        --system-prompt "You write git commit messages. Reply with the commit message only: no preamble, no code fences, no trailers. Match the style of the recent subjects. Keep the subject under 72 characters and add a body only when the change needs explaining." \
        | tee /dev/stderr | wl-copy --trim-newline
    '';
  };
  commitMsgTask = "commit message to clipboard";
in {
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

    userTasks = [
      {
        label = commitMsgTask;
        command = lib.getExe commit-msg;
        reveal = "no_focus";
        hide = "on_success";
        allow_concurrent_runs = false;
      }
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
      # Takes over the default git::GenerateCommitMessage binding
      {
        context = "GitCommit > Editor && mode == auto_height";
        bindings.alt-l = ["task::Spawn" {task_name = commitMsgTask;}];
      }
      {
        context = "CommitEditor > Editor";
        bindings.alt-l = ["task::Spawn" {task_name = commitMsgTask;}];
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
      git_panel.dock = "right";
      outline_panel.dock = "left";
      debugger.dock = "bottom";
      collaboration_panel = {
        dock = "right";
        button = false;
      };

      # window.controlsStyle = "hidden": niri draws no decorations of its own
      window_decorations = "server";

      # AI stays out of the way but reachable: predictions only on alt-\,
      # agents from the agent panel. disable_ai would remove both.
      edit_predictions.provider = "copilot";
      show_edit_predictions = true;
      agent_servers = {
        claude-acp = {
          type = "registry";
          default_config_options.mode = "auto";
        };
        antigravity-acp = {
          type = "registry";
          default_config_options.model = "gemini-pro-agent";
        };
        github-copilot-cli.type = "registry";
        opencode.type = "registry";
      };
      agent = {
        enable_feedback = false;
        dock = "right";
        # A flexible panel ignores default_width and opens at half the window.
        # 300 is the narrowest the panel goes.
        flexible = false;
        default_width = 300;
        threads_sidebar.position = "right";
      };
      title_bar = {
        #show_sign_in = false;
        show_onboarding_banner = false;
      };

      languages.Nix = {
        language_servers = ["nil" "!nixd"];
        format_on_save = "on";
      };

      lsp.nil = {
        binary.path = "nil";
        settings = {
          formatting.command = ["nixfmt"];
          # Unset, nil asks to fetch missing flake inputs on every start
          nix.flake.autoArchive = true;
        };
      };
    };
  };
}
