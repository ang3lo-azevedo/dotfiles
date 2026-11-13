{inputs, ...}: let
  utils = inputs.nixCats.utils;
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
        };
      };
    };
  };
}
