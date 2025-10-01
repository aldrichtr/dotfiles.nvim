
local M = {}
setmetatable(M, {
  __index = M,
  __call = function(cls,...) return cls:init(...) end
})

function M:init(opt)
  vim.o.fileformats = 'unix'
  --
  -- #region Buffer elements

  -- Enable modelines in files
  vim.o.modeline = true
  -- On the first and last two lines
  vim.o.modelines = 2

  -- ! use the vscode region markers for folding by default
  vim.o.foldmethod = 'marker'
  vim.o.foldmarker = '#region,#endregion'

  vim.o.number = true -- Show the current line numbers
  vim.o.relativenumber = true -- and relative number

  vim.o.ruler = true -- Show the cursor position in the status bar
  vim.o.cursorline = true -- Highlight the current line
  vim.opt.cursorlineopt = { 'number', 'line' }

  -- #region spaces and tabs
  vim.o.expandtab = true -- Insert spaces instead of tabs
  vim.o.smarttab = true  -- Insert spaces according to shift width
  vim.o.shiftwidth = 2   -- when shifting lines
  vim.o.tabstop = 2      -- how many spaces is a tab worth
  vim.o.softtabstop = 2  -- while performing editing

  vim.o.list = true -- Show Whitespace
  vim.opt.listchars = {
    tab = '>-',
    trail = '·',
  }
  -- #endregion spaces and tabs
  -- #endregion Buffer elements
  -- ------------------------------------------------------------------------

  -- ------------------------------------------------------------------------
  -- #region Editor functions

  -- #region search
  vim.o.hlsearch = true -- Highlight results of search
  vim.o.incsearch = true --  incrementally

  vim.o.ignorecase = true -- Ignore case,
  vim.o.smartcase = true --  unless there are capitals in the pattern
  vim.o.magic = true -- Change the special characters in search patterns
  -- #endregion search
  -- #endregion Editor functions
  -- ------------------------------------------------------------------------
end

return M
