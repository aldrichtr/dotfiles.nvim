
local normalize = vim.fs.normalize

local Path = {
  -- Convenience alias to joinpath
  join = vim.fs.joinpath,

  -- This is neovim's configuration directory, where init.lua lives
  -- $env:XDG_USER_CONFIG_DIR/nvim
  init = normalize(vim.fn.stdpath('config')),
  -- This is neovim's local directory, where packages, tools, and libraries are stored
  -- $env:XDG_USER_DATA_DIR/nvim-data
  data = normalize(vim.fn.stdpath('data')),

  -- Environmental paths (windows though)
  LocalAppData = normalize(vim.env.LOCALAPPDATA),
  AppData = normalize(vim.env.APPDATA),
  Home = vim.env.HOME,
  Programs = normalize(vim.env.ProgramFiles)
}

Path.dotfiles = Path.join(Path.Home, '.dotfiles')

Path.lua = Path.join(Path.init, 'lua')
-- TODO: This might be confusing because it seems like stdpath('config') should be `config` but it is the path to the main config of my init `lua/config`
Path.config = Path.join(Path.lua, 'config')

Path.lsp = { root = Path.join(vim.env.LOCALAPPDATA, 'lsp'),
             logs = Path.join(Path.data, 'logs') }

Path.lsp['lua'] = Path.join(Path.lsp.root, 'lua')
Path.lsp['pses'] = Path.join(Path.lsp.root, 'pses')


function Path.exists(p)
	return vim.uv.fs_stat(p)
end

-- ------------------------------------------------------------------------------
---@param file string fully-qualified path to a lua file
---@return string "dot-separated" path to file
function Path.convert_to_module(file)
  local root = normalize(Path.lua)

  -- format the file name
  local filename = normalize(file)
  if vim.fs.basename(filename):match("^init") then
    filename = vim.fs.dirname(filename)
  else
    filename = filename:gsub("%.lua", "")
  end
  local rel = vim.fs.relpath(Path.lua, filename)

  local module = rel:gsub("/", ".")
  return module
end

function Path.convert_to_path(mod)
  local file = mod:gsub("%.","/")
  file = Path.join(Path.lua, file)
  file = file .. '.lua'
  return Path.join(Path.lua, file)
end


---@param int count the number of callers back from the
---caller of this function.  0 or nil is the calling function,
---1 would be the caller of the caller, etc.
---@return string Path to the callers file
function Path.caller(count)
  local jumps = 0
  if count == nil then
    jumps = 2 -- the function that called path.caller()
  else
    jumps = count + 2 -- one for path.caller() and one for caller
  end
  local caller = debug.getinfo(jumps,'S')
  return normalize(caller.source:sub(2))
end

function Path.find(...)
  local directory, match, exclude, details
  if type(...) == 'table' then
    local opts = ...
    directory = opts.dir or nil
    match     = opts.match or "(.+).lua$"
    exclude   = opts.exclude or {}
    details   = opts.details or {limit = math.huge, type = 'file'}
  else
    directory, match, exclude, details = ...
  end

  -- use the callers directory if not given
  if directory == nil then
    info = debug.getinfo(2, 'S')
    directory = vim.fs.dirname(info.short_src)
  end
  -- the info in debug.getinfo has two paths:
  -- - `source` which has an '@' sign before it
  -- - `short_src` which does not

  -- if it does, remove it
  if directory and string.sub(directory, 1, 1) == "@" then
    -- Strip this off if present
    directory = string.sub(directory, 2)
  end

  details['path'] = directory

  return vim.fs.find(
    function(name, path)
      return name:match(match) and not exclude[name]
    end,
    details)
end


return Path
