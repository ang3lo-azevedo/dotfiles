{
  lib,
  pkgs,
  config,
  ...
}: let
  commit-msg = pkgs.writeShellApplication {
    name = "zed-commit-msg";
    runtimeInputs = [
      pkgs.git
      pkgs.wl-clipboard
    ];
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
  rightDockWidth = 300;
  mkModel = name: display_name: {
    inherit name display_name;
    max_tokens = 65536;
  };

  # Zed derives a custom provider's API-key env var from the provider id, upper
  # snake case plus _API_KEY: gemini-web2api becomes GEMINI_WEB2API_API_KEY.
  # Load it from the age secret at launch so the key never lands in the Nix
  # store, and wrap the PATH-relative `zeditor` the desktop entry calls.
  keyLoader = ''
    if [ -z "''${GEMINI_WEB2API_API_KEY:-}" ]; then
      for p in /run/agenix /run/secrets; do
        if [ -f "$p/gemini_api_key" ]; then
          export GEMINI_WEB2API_API_KEY="$(cat "$p/gemini_api_key")"
          break
        fi
      done
    fi
  '';
  zedPackage = pkgs.symlinkJoin {
    name = "zed-editor-web2api";
    paths = [pkgs.zed-editor];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm -f "$out/bin/zeditor"
      makeWrapper ${pkgs.zed-editor}/bin/zeditor "$out/bin/zeditor" \
        --run ${lib.escapeShellArg keyLoader}
    '';
  };
in {
  # The web2api base URL is a secret, so it cannot live in the Nix-managed
  # settings.json: inject it into the custom provider's api_url at activation
  home.activation.zedOpenAiUrl = lib.hm.dag.entryAfter ["writeBoundary"] ''
    zedSettings="${config.home.homeDirectory}/.config/zed/settings.json"
    for p in /run/agenix /run/secrets; do
      if [ -f "$p/gemini_base_url" ] && [ -f "$zedSettings" ]; then
        BASE_URL="$(cat "$p/gemini_base_url")"
        $DRY_RUN_CMD ${pkgs.jq}/bin/jq --arg url "$BASE_URL/v1" '.language_models.openai_compatible["gemini-web2api"].api_url = $url' "$zedSettings" > "$zedSettings.tmp"
        $DRY_RUN_CMD mv -f "$zedSettings.tmp" "$zedSettings"
        break
      fi
    done
  '';

  # Fonts come from the stylix zed target.
  programs.zed-editor = {
    enable = true;
    package = zedPackage;

    themes.perfect-dark = import ./zed-perfect-dark.nix;

    # Language servers Zed cannot fetch itself: it builds gopls with `go install`, and
    # the Semgrep and PowerShell extensions only wrap a binary that must already be there
    extraPackages = with pkgs; [
      gopls
      powershell
      semgrep
    ];

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
          delete = [
            "project_panel::Trash"
            {skip_prompt = true;}
          ];
          backspace = [
            "project_panel::Trash"
            {skip_prompt = true;}
          ];
        };
      }
      # Takes over the default git::GenerateCommitMessage binding
      {
        context = "GitCommit > Editor && mode == auto_height";
        bindings.alt-l = [
          "task::Spawn"
          {task_name = commitMsgTask;}
        ];
      }
      {
        context = "CommitEditor > Editor";
        bindings.alt-l = [
          "task::Spawn"
          {task_name = commitMsgTask;}
        ];
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
      # Inferred types and parameter names inline, from the language servers
      inlay_hints.enabled = true;
      # mkForce: the stylix zed target sets its own base16 theme
      theme = lib.mkForce "Perfect Dark";
      icon_theme = "Material Icon Theme";

      # Every panel of the right dock opens at the width of the agent panel
      project_panel = {
        dock = "right";
        default_width = rightDockWidth;
      };
      git_panel = {
        dock = "right";
        default_width = rightDockWidth;
      };
      outline_panel.dock = "left";
      debugger.dock = "bottom";
      collaboration_panel = {
        dock = "right";
        button = false;
        default_width = rightDockWidth;
      };

      # window.controlsStyle = "hidden": niri draws no decorations of its own
      window_decorations = "server";

      # AI stays out of the way but reachable: predictions only on alt-\,
      # agents from the agent panel. disable_ai would remove both.
      # Zeta, Zed's own model: needs a signed-in Zed account on a plan that includes it
      edit_predictions = {
        provider = "zed";
        mode = "subtle";
      };
      agent_servers = {
        claude-acp = {
          type = "registry";
          default_config_options.mode = "auto";
        };
        # Run Nix-provided Google Antigravity in ACP mode instead of the outdated registry build
        antigravity-acp = {
          command = "${pkgs.google-antigravity-cli}/bin/agy";
          args = ["acp"];
        };
        github-copilot-cli.type = "registry";
        # Run the Nix-provided opencode in ACP mode instead of the registry type, which
        # makes Zed download its own opencode build (2.2.2) on every launch. Nix pins the
        # version and updates it on rebuild.
        opencode = {
          command = lib.getExe pkgs.opencode;
          args = ["acp"];
        };
      };
      # Custom OpenAI-compatible provider for the gemini-web2api server. Using a
      # named provider instead of the built-in `openai` one keeps Zed's default
      # GPT models out of the picker (they would hit this endpoint and fail).
      # Both secrets come from agenix: api_url is injected into settings.json at
      # activation, the API key through the GEMINI_WEB2API_API_KEY env var the
      # wrapped launcher sets.
      # Models are the full list from GET /v1/models; the media models are kept
      # for completeness though Zed's agent only drives the text ones.
      language_models.openai_compatible.gemini-web2api.available_models = [
        (mkModel "gemini-4-neon" "Gemini 4 Neon")
        (mkModel "gemini-4-neon-thinking" "Gemini 4 Neon (Thinking)")
        (mkModel "gemini-4-argon" "Gemini 4 Argon")
        (mkModel "gemini-4-argon-thinking" "Gemini 4 Argon (Thinking)")
        (mkModel "gemini-4-argon-thinking-medium" "Gemini 4 Argon (Thinking Medium)")
        (mkModel "gemini-4-carbon" "Gemini 4 Carbon")
        (mkModel "gemini-4-hydrogen" "Gemini 4 Hydrogen")
        (mkModel "gemini-4-hydrogen-thinking" "Gemini 4 Hydrogen (Thinking)")
        (mkModel "gemini-3.8-flash" "Gemini 3.8 Flash")
        (mkModel "gemini-3.8-flash-thinking" "Gemini 3.8 Flash (Thinking)")
        (mkModel "gemini-3.7-flash" "Gemini 3.7 Flash")
        (mkModel "gemini-3.7-flash-thinking" "Gemini 3.7 Flash (Thinking)")
        (mkModel "gemini-3.6-flash" "Gemini 3.6 Flash")
        (mkModel "gemini-3.6-flash-thinking" "Gemini 3.6 Flash (Thinking)")
        (mkModel "gemini-3.5-flash-lite" "Gemini 3.5 Flash Lite")
        (mkModel "gemini-3.5-flash-lite-thinking" "Gemini 3.5 Flash Lite (Thinking)")
        (mkModel "gemini-3.1-pro" "Gemini 3.1 Pro")
        (mkModel "gemini-3.1-pro-thinking" "Gemini 3.1 Pro (Thinking)")
        (mkModel "gemini-video" "Gemini Video")
        (mkModel "gemini-image" "Gemini Image")
        (mkModel "gemini-canvas" "Gemini Canvas")
        (mkModel "gemini-music" "Gemini Music")
      ];
      agent = {
        enable_feedback = false;

        # Default to Gemini 4 Hydrogen via the gemini-web2api server; the lighter
        # 3.8 Flash handles commit messages.
        default_model = {
          provider = "gemini-web2api";
          model = "gemini-4-hydrogen";
        };
        commit_message_model = {
          provider = "gemini-web2api";
          model = "gemini-3.8-flash";
        };

        dock = "right";
        # A flexible panel ignores default_width and opens at half the window.
        # 300 is the narrowest the panel goes.
        flexible = false;
        default_width = rightDockWidth;
        threads_sidebar = {
          position = "right";
          default_width = 200;
        };
      };
      title_bar = {
        #show_sign_in = false;
        show_onboarding_banner = false;
      };

      languages.Nix = {
        language_servers = [
          "nil"
          "!nixd"
        ];
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
