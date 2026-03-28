local path = require('util.path')

local parser_dir = path.join(path.LocalAppData, 'tree-sitter')

local M = {
  'nvim-treesitter/nvim-treesitter'
}

M.branch = 'main'

M.build = ':TSUpdate'

M.lazy = false

-- we need to put this path at the beginning so that we override the builtin
-- parsers
M.init = function()
  if not path.exists(parser_dir) then
    log.debug("treesitter parsers directory does not exist.  Creating", parser_dir)
    vim.fn.mkdir(parser_dir, "p")
  end
  vim.opt.runtimepath:prepend(parser_dir)

  local ts = require('nvim-treesitter')

end

M.opts = {
  install_dir = parser_dir,

  -- A list of parser names, or "all"
  ensure_installed = { 'bash', 'lua', 'powershell', 'yaml' },
  ignore_install = {},
  modules = {},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
  auto_install = true,

  indent = {
    enable = true,
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = { 'markdown' },
  }
}

return M
