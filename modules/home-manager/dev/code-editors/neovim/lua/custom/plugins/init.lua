-- Custom plugins, loaded on top of kickstart. Plugins themselves are pinned by
-- nix (see startupPlugins in default.nix); these specs only configure them.

return {
  -- GitHub Copilot integration, mirroring the Zed edit-predictions/Copilot
  -- setup. The copilot-language-server binary comes from nix; run `:Copilot auth`
  -- once to sign in. In-menu completions are fed into nvim-cmp via copilot-cmp.
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    keys = {
      {
        '<leader>tc',
        function()
          local client = require 'copilot.client'
          local command = require 'copilot.command'
          if client.is_disabled() then
            command.enable()
            vim.notify('Copilot: Enabled (global)', vim.log.levels.INFO, { title = 'Copilot' })
          else
            command.disable()
            vim.notify('Copilot: Disabled (global)', vim.log.levels.WARN, { title = 'Copilot' })
          end
        end,
        desc = '[T]oggle [C]opilot (Global on/off)',
      },
      {
        '<leader>tb',
        function()
          local client = require 'copilot.client'
          local command = require 'copilot.command'
          command.toggle()
          if client.buf_is_attached(0) then
            vim.notify('Copilot: Attached to buffer', vim.log.levels.INFO, { title = 'Copilot' })
          else
            vim.notify('Copilot: Detached from buffer', vim.log.levels.WARN, { title = 'Copilot' })
          end
        end,
        desc = '[T]oggle Copilot in current [B]uffer',
      },
    },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  -- lazygit integration, mirroring the Zed git panel. <leader>gg opens it.
  -- The lazygit binary comes from nix (see lspsAndRuntimeDeps).
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = '[G]it: lazy[g]it' },
    },
  },

  -- Google Antigravity AI Assistant via NakLast/antigravity-cli.nvim.
  -- Uses `agy` (pinned in lspsAndRuntimeDeps). Docks as a persistent vertical
  -- split sidebar (style = 'vsplit') beside your code.
  {
    'NakLast/antigravity-cli.nvim',
    cmd = 'Antigravity',
    keys = {
      { '<leader>ag', '<cmd>Antigravity<cr>', desc = '[A]ntigravity: toggle [g]UI' },
      { '<leader>aa', '<cmd>Antigravity<cr>', desc = '[A]ntigravity: toggle sidebar chat' },
      {
        '<leader>as',
        function()
          require('antigravity').ask_selection()
        end,
        mode = { 'n', 'v' },
        desc = '[A]ntigravity: ask [s]election',
      },
    },
    opts = {
      cmd = 'agy',
      width_ratio = 0.38,
      border = 'rounded',
      style = 'vsplit',
    },
  },

  -- CodeCompanion: Cursor-like AI sidebar chat, inline edits, and diff reviews.
  -- Uses your existing Copilot subscription as default LLM backend.
  {
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanionCmd' },
    keys = {
      { '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[C]odeCompanion: toggle [c]hat sidebar' },
      { '<leader>cp', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[C]odeCompanion: actions [p]alette' },
      { '<leader>ci', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = '[C]odeCompanion: [i]nline assistant' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      interactions = {
        chat = {
          adapter = 'copilot',
          roles = {
            llm = 'CodeCompanion (Copilot)',
            user = 'You',
          },
        },
        inline = {
          adapter = 'copilot',
        },
      },
      display = {
        chat = {
          window = {
            layout = 'vertical',
            width = 0.38,
          },
        },
        diff = {
          provider = 'mini_diff',
        },
      },
    },
  },

  -- Surround actions: add, delete, change surroundings (quotes, parens, tags)
  -- e.g. cs"' (change " to '), ysiw" (surround word with "), ds( (delete parens)
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {},
  },

  -- Trouble: Pretty list for diagnostics, references, quickfix, and symbols
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions/References (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
    opts = {},
  },

  -- Flash: 2-character search & instant jump navigation
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash Jump',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
    },
  },

  -- Auto-close & auto-rename HTML, XML, JSX, TSX tags with Tree-sitter
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Typst live preview in browser with bidirectional cursor sync
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    cmd = { 'TypstPreview', 'TypstPreviewToggle', 'TypstPreviewUpdate', 'TypstPreviewSyncCursor', 'TypstPreviewStop' },
    keys = {
      { '<leader>tp', '<cmd>TypstPreviewToggle<cr>', desc = '[T]ypst: toggle [p]review' },
      { '<leader>ts', '<cmd>TypstPreviewSyncCursor<cr>', desc = '[T]ypst: [s]ync cursor' },
    },
    opts = {
      dependencies_bin = {
        ['tinymist'] = 'tinymist',
        ['websocat'] = 'websocat',
      },
    },
  },
}
