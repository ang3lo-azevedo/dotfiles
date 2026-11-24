{
  inputs,
  config,
  ...
}: let
  utils = inputs.nixCats.utils;

  # Drive neovim's colours from stylix base16, but keep neovim's editor background
  # at #0a0a0a (deep dark, avoiding OLED #000000) with #111111 for statusline/sidebars.
  stylixBase16 = let
    c = config.lib.stylix.colors.withHashtag;
  in {
    inherit
      (c)
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      base0F
      ;
    base00 = "#0a0a0a";
    base01 = "#111111";
    base02 = "#1c1c1c";
  };
in {
  imports = [
    inputs.nixCats.homeModule
  ];

  # Full-featured neovim (kickstart.nvim) built with nixCats: the Lua config in this
  # directory is plain upstream kickstart, while nix pins every plugin and LSP so the
  # editor is reproducible and rolls back with the system. lazy.nvim still does the
  # loading, but from the nix store rather than fetching at run time.
  config.nixCats = {
    enable = true;

    # Exposes any inputs named plugins-<name> as pkgs.neovimPlugins. None are wired
    # yet, but the overlay is harmless and ready for custom plugins later.
    addOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    packageNames = ["nvim"];
    luaPath = ./.;

    categoryDefinitions.replace = {pkgs, ...}: {
      # Available on PATH inside neovim at run time, including the LSP servers.
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          universal-ctags
          ripgrep
          fd
          stdenv.cc.cc
          nix-doc
          lua-language-server
          tree-sitter
          nixd
          stylua
          # clangd for C/C++ LSP and completion (enabled in init.lua servers).
          clang-tools
          # LSP servers for the languages used in the Zed config.
          gopls
          go # gofmt, and the go toolchain gopls needs
          pyright
          ruff # python lint + ruff_format formatter
          bash-language-server
          tinymist # typst LSP & preview engine
          websocat # websocket bridge for typst-preview.nvim
          alejandra # nix formatter (format-on-save via conform)
          # Clipboard integration on Wayland (wl-copy, wl-paste).
          wl-clipboard
          # Copilot inline suggestions and lazygit integration.
          copilot-language-server
          lazygit
          # Google Antigravity CLI for AI chat and assistance.
          google-antigravity-cli
          # Claude Code CLI, Node.js, and ACP bridges for CodeCompanion/Zed
          claude-code
          nodejs
          (writeShellScriptBin "claude-agent-acp" ''
            exec ${pkgs.nodejs}/bin/npx -y @agentclientprotocol/claude-agent-acp "$@"
          '')
          (writeShellScriptBin "gemini" ''
            args=()
            is_acp=false
            for arg in "$@"; do
              if [ "$arg" = "--experimental-acp" ]; then
                is_acp=true
              elif [ "$arg" = "--yolo" ]; then
                args+=("--dangerously-skip-permissions")
              else
                args+=("$arg")
              fi
            done

            if [ "$is_acp" = true ] || [ "''${1:-}" = "acp" ]; then
              exec ${pkgs.google-antigravity-cli}/bin/agy acp "''${args[@]}"
            else
              exec ${pkgs.google-antigravity-cli}/bin/agy "''${args[@]}"
            fi
          '')
        ];
        kickstart-debug = [
          delve
        ];
        kickstart-lint = [
          markdownlint-cli
        ];
      };

      # Loaded at startup. lazy.nvim takes over the actual loading from here.
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          vim-sleuth
          lazy-nvim
          comment-nvim
          gitsigns-nvim
          which-key-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          nvim-web-devicons
          plenary-nvim
          nvim-lspconfig
          lazydev-nvim
          fidget-nvim
          conform-nvim
          nvim-cmp
          luasnip
          cmp_luasnip
          cmp-nvim-lsp
          cmp-path
          tokyonight-nvim
          todo-comments-nvim
          mini-nvim
          nvim-treesitter.withAllGrammars
          # Custom additions (configured in lua/custom/plugins): Copilot inline
          # suggestions, lazygit, and Antigravity AI.
          copilot-lua
          copilot-cmp
          friendly-snippets
          lazygit-nvim
          codecompanion-nvim
          lspkind-nvim
          nvim-surround
          trouble-nvim
          flash-nvim
          nvim-ts-autotag
          typst-preview-nvim
          (pkgs.vimUtils.buildVimPlugin {
            pname = "antigravity-cli.nvim";
            version = "unstable-2026-03-24";
            src = pkgs.fetchFromGitHub {
              owner = "NakLast";
              repo = "antigravity-cli.nvim";
              rev = "main";
              hash = "sha256-WFmvFexY0B/1NOdlPmdGCVu/Kv8XGekkMRk8H8mmnio=";
            };
          })
        ];
        kickstart-debug = [
          nvim-dap
          nvim-dap-ui
          nvim-dap-go
          nvim-nio
        ];
        kickstart-indent_line = [
          indent-blankline-nvim
        ];
        kickstart-lint = [
          nvim-lint
        ];
        kickstart-autopairs = [
          nvim-autopairs
        ];
        kickstart-neo-tree = [
          neo-tree-nvim
          nui-nvim
          nvim-web-devicons
          plenary-nvim
        ];
      };

      optionalPlugins = {};

      sharedLibraries = {
        general = with pkgs; [];
      };
    };

    packageDefinitions.replace = {
      nvim = _: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          # Shadows the system vim with neovim on the user PATH. Drop this alias to
          # keep plain vim as a separate editor.
          aliases = ["vim"];
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;

          kickstart-autopairs = true;
          kickstart-neo-tree = true;
          kickstart-debug = true;
          kickstart-lint = true;
          kickstart-indent_line = true;
          kickstart-gitsigns = true;

          # The JetBrainsMono Nerd Font is already installed, so enable glyph icons.
          have_nerd_font = true;

          # The stylix base16 palette, read in lua via nixCats('base16').
          base16 = stylixBase16;
        };
      };
    };
  };
}
