
Path = {
  -- Convenience alias to joinpath
  join = vim.fs.joinpath,

  -- This is neovim's configuration directory, where init.lua lives
  -- $env:XDG_USER_CONFIG_DIR/nvim
  init = vim.fn.stdpath('config'),
  -- This is neovim's local directory, where packages, tools, and libraries are stored
  -- $env:XDG_USER_DATA_DIR/nvim-data
  data = vim.fn.stdpath('data')
}

Path.lua = Path.join(Path.init, 'lua')
-- TODO: This might be confusing because it seems like stdpath('config') should be `config`
Path.config = Path.join(Path.lua, 'config')

Path.lsp = {}
Path.lsp['root'] = Path.join(vim.env.LOCALAPPDATA, 'lsp') 

Path.lsp['lua'] = Path.join(Path.lsp.root, 'lua')

---@param string fully-qualified path to a lua file
---@return string "dot-separated" path to file
function Path.convert_to_module(file)
  local filename = file
  local rel = filename:gsub(Path.lua, ""):gsub(".lua", "")
  local module = rel:gsub("\\", "."):gsub("/", ".")
  return module
end

setmetatable(Path, { __index = Path })

return Path
