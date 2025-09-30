
local M = {
  -- #region Interface

  -- #region colorschemes
  require('packages.colorscheme.melange'),
  require('packages.colorscheme.rose-pine'),
  require('packages.colorscheme.darcula-dark'),
  require('packages.colorscheme.grail'),
  require('packages.colorscheme.no-clown-fiesta'),
  -- #endregion colorschemes

  require('packages.bufferline'),
  require('packages.cmp'),
  require('packages.compl'),
  require('packages.lualine'),
  -- Decorators
  require('packages.noice'),
  require('packages.nui'),
  require('packages.nvim-notify'),
  require('packages.indent-blankline'),
  require('packages.rainbow-delimiters'),
  require('packages.ufo'),

  -- Views
  require('packages.dashboard'),
  require('packages.neo-tree'),
  require('packages.aerial'),
  require('packages.toggleterm'),
  require('packages.trouble'),

  -- #endregion Interface
  -- #region Tools
  require('packages.harpoon'),
  require('packages.luasnip'),
  require('packages.colortils'),
  require('packages.conform'),
  require('packages.project'),
  require('packages.neoconf'),
  require('packages.neogit'),
  -- #endregion Tools

  -- #region Filetype
  require('packages.helpview'),
  require('packages.markdown-preview'),
  require('packages.powershell'),
  -- #endregion Filetype

  -- Support
  require('packages.image'),
  require('packages.luvit-meta'),
  require('packages.lazydev'),
  require('packages.plenary'),
  require('packages.treesitter'),
  require('packages.treesitter-textobjects'),
  require('packages.scope'),
  require('packages.vim-polyglot'),
  require('packages.web-devicons'),

  -- Editing
  require('packages.lspconfig'),
  require('packages.lsp-file-operations'),
  require('packages.lspkind'),
  require('packages.neogen'),
  require('packages.open-link'),
  require('packages.repeat'),
  require('packages.surround'),
  require('packages.autoclose'),
  require('packages.tabout'),
  require('packages.telescope'),
  require('packages.todo-comments'),
  require('packages.whichkey'),
  require('packages.window-picker')
}

return M
