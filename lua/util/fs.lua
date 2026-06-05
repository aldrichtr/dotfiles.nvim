
local is = require('util.is')

local luaDir = vim.fn.stdpath('config') .. '/lua'

local fs = {}

-- SECTION Path components
-- fix some non-standard naming in the vim.fs object
---@param path string a filesystem path
---@return string The filename (without the directory) of path
fs.filename = function(path)
  return vim.fs.basename(path)
end

---@param path string a filesystem path
---@return string the fullname of the parent directory of path
fs.parent = function(path)
  return vim.fs.dirname(path)
end
fs.directory = fs.parent

---@param path string a filesystem path
---@return string The file extension
fs.extension = function(path)
  return vim.fs.ext(path)
end

---@param path string a filesystem path
---@return string The name of the directory path is in
fs.directoryname = function(p)
  local path = vim.fs.dirname
  return vim.fs.basename(path)
end


---@param path string a filepath
---@return string The name of the file without its extension
fs.basename = function(path)
  local file = fs.filename(path)
  local ext  = fs.extension(path)
  return file:gsub(ext,'')
end

-- !SECTION

-- SECTION Path testing functions
---@param p string potential path to a directory or file
---@return boolean true if the directory or file is present on the system
function fs.exists(p)
  if vim.uv.fs_stat(p) then
    return true
  else
    return false
  end
end
-- !SECTION

-- SECTION Path manipulation functions

---@param ... string[] A list of path components to be joined
---@return string A normalized path
fs.join = function(...)
  local path = vim.fs.joinpath(...)
  return fs.normalize(path)
end

---@param
function fs.normalize(path)
  local result
  result = vim.fs.normalize(path)
  return vim.fs.abspath(result)
end



--- Convert a file path to a module specific, such as:
--- ~/.config/nvim/lua/config/foo.lua => 'config.foo'
---@param file string fully-qualified path to a lua file
---@return string "dot-separated" path to file
function fs.convert_to_module(file)
  local filename, relpath, modpath
  local root = luaDir
  Logger:trace("converting file '" .. file .. "' to module")
  filename = fs.normalize(file)

  if vim.fs.basename(filename):match("^init") then
    filename = vim.fs.dirname(filename)
  else
    filename = filename:gsub("%.lua", "")
  end
  Logger:trace("Getting relative path for '" .. filename .. "' from '" .. root .. "'")
  relpath = vim.fs.relpath(root, filename)
  if is.present(relpath) then
    Logger:trace("Now creating module name from '" .. relpath .. "'")
    modpath = relpath:gsub("/", ".")
    return modpath
  else
    error("attempt to convert non-init path '" .. file .. "'", 1)
  end
end

--- Convert a module specification to a file path, such as:
--- 'config.foo' => ~/.config/nvim/lua/config/foo.lua
function fs.convert_to_path(mod)
  local file = mod:gsub("%.","/")
  file = fs.join(luaDir, file)
  file = file .. '.lua'
  return fs.join(luaDir, file)
end


---@param count integer  the number of callers back from the
---caller of this function.  0 or nil is the calling function,
---1 would be the caller of the caller, etc.
---@return string Path to the callers file
function fs.caller(count)
  local jumps = 0
  if count == nil then
    jumps = 2 -- the function that called fs.caller()
  else
    jumps = count + 2 -- one for fs.caller() and one for caller
  end
  local caller = debug.getinfo(jumps,'S')
  return normalize(caller.source:sub(2))
end

---@param dir string The root directory to find files in
---@param match string A pattern to apply to file names for inclusion
---@param exclude table A list of file names to exclude
---@param details table Details to pass to the vim find cmd. limit and type
function fs.find(...)
  local params = ...
  local directory, match, exclude, details, files

  if is.a_string(params) then
    directory = params
  elseif is.a_table(params) then
    directory = params.dir or params[0] or nil
    match     = params.match or params[1] or nil
    exclude   = params.exclude or params[2] or nil
    details   = params.details or params[3] or nil
  else
    directory, match, exclude, details = ...
  end

  if is.a_table(params) then
    for k,v in pairs(params) do
      Logger:trace(string.format("Parameter '%s' => '%s'", k, v))
    end
  end

  -- Handle any empty params ------------------------------------------------
  -- 1. directory -----------------------------------------------------------
  -- use the callers directory if not given
  if is.empty(directory) then
    info = debug.getinfo(2, 'S')
    directory = vim.fs.dirname(info.short_src)
  end
  -- the info in debug.getinfo has two paths:
  -- - `source` which has an '@' sign before it
  -- - `short_src` which does not

  -- if it does, remove it
  if string.sub(directory, 1, 1) == "@" then
    directory = string.sub(directory, 2)
  end
  -- 2. match --------------------------------------------------------------
  if is.empty(match) then
    match = "(.+).lua$"
  end
  -- 3. exclude ------------------------------------------------------------
  if is.empty(exclude) then
    exclude = {}
  end
  -- 4. details ------------------------------------------------------------

  if is.empty(details) then
    details = {limit = math.huge, type = 'file', path = directory}
  elseif is.a_table(details) then
    if is.empty(details['limit']) then
      details['limit'] = math.huge
    end
    if is.empty(details['type']) then
      details['type'] = 'file'
    end
    if is.empty(details['path']) then
      details['path'] = directory
    end
  else
    details = {limit = math.huge, type = 'file', path = directory}
  end
  -- -----------------------------------------------------------------------

  Logger:trace(string.format("Finding files in '%s' that match '%s'", details.path, match))
  files = vim.fs.find(
    function(name, path)
      return name:match(match) and not exclude[name]
    end , details)

  Logger:trace("- found " .. table.concat(files, ", "))
  return files
end


return fs
