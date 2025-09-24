-- Provide some Standard Library variables and functions

local joinpath = vim.fs.joinpath
M = {}

-- #region Paths to significant directories and files
M.path = {
  -- This is neovim's configuration directory, where init.lua lives
  -- $env:XDG_USER_CONFIG_DIR/nvim
  init = vim.fn.stdpath('config'),
  -- This is neovim's local directory, where packages, tools, and libraries are stored
  -- $env:XDG_USER_DATA_DIR/nvim-data
  data = vim.fn.stdpath('data'),

  -- Convenience alias to joinpath
  join = joinpath
}

M.path.lua = joinpath(M.path.init, 'lua')

M.path.config = joinpath(M.path.lua, 'config')
-- #endregion Paths to significant directories and files

M.file = {
  init = joinpath(M.path.init, 'init.lua'),
  options = joinpath(M.path.lua, 'options')
}

return M
