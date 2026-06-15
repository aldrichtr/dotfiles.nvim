
local is = require('util.is')

local luaDir = vim.fn.stdpath('config') .. '/lua'
local NeovimFs = vim.fs


local FileSystem = {}

-- SECTION Path components

-- fix some non-standard naming in the `vim.fs` object

---@param path string a filesystem path
---@return string The filename (without the directory) of path
function FileSystem.filename(path)
  return NeovimFs.basename(path)
end

---@param path string a filesystem path
---@return string the fullname of the parent directory of path
function FileSystem.parent(path)
  return NeovimFs.dirname(path)
end

-- alias directory to parent
FileSystem.directory = FileSystem.parent

---@param path string a filesystem path
---@return string The file extension
function FileSystem.extension(path)
  return NeovimFs.ext(path)
end

---@param path string a filesystem path
---@return string The name of the directory path is in
function FileSystem.directoryname(path)
  local p = NeovimFs.dirname(path)
  return NeovimFs.basename(p)
end


---@param path string a filepath
---@return string The name of the file without its extension
function FileSystem.basename(path)
  local file = FileSystem.filename(path)
  local ext  = FileSystem.extension(path)
  local s, _ = file:gsub(ext,'')
  return s
end

-- !SECTION

-- SECTION Path testing functions
---@public
---@param path string potential path to a directory or file
---@return boolean true if the directory or file is present on the system
function FileSystem.exists(path)
  if vim.uv.fs_stat(path) then
    return true
  else
    return false
  end
end
-- !SECTION

-- SECTION Path manipulation functions

---@public
---@param ... string|string[] A list of path components to be joined
---@return string A normalized path
function FileSystem.join(...)
  local path = NeovimFs.joinpath(...)
  return FileSystem.normalize(path)
end

---@param path string A (possibly) non-standard path specification
---@return string A fully-qualified, expanded path
function FileSystem.normalize(path)
  local result
  result = NeovimFs.normalize(path)
  return NeovimFs.abspath(result)
end

-- !SECTION

-- SECTION Path conversion functions

--- Convert a file path to a module specific, such as:
--- ~/.config/nvim/lua/config/foo.lua => 'config.foo'
---@param file string fully-qualified path to a lua file
---@return string "dot-separated" path to file
function FileSystem.convert_to_module(file)
  local filename, relpath, modpath
  local root = luaDir
  filename = FileSystem.normalize(file)

  if NeovimFs.basename(filename):match("^init") then
    filename = NeovimFs.dirname(filename)
  else
    filename, _ = filename:gsub("%.lua", "")
  end
  relpath = NeovimFs.relpath(root, filename)
  if is.present(relpath) then
    modpath, _ = relpath:gsub("/", ".")
    return modpath
  else
    error("attempt to convert non-init path '" .. file .. "'", 1)
  end
end

--- Convert a module specification to a file path, such as:
--- 'config.foo' => ~/.config/nvim/lua/config/foo.lua
function FileSystem.convert_to_path(mod)
  local file,_ = mod:gsub("%.","/")
  file = file .. '.lua'
  return FileSystem.join(luaDir, file)
end

-- !SECTION


---@private
--- This function is used by the find() function to determine if the given file
--- and path meet the qualifiers.
--- @param name string the name of the file
--- @param path string The path the file is in
--- @param matches string[] List of 0 or more regex to apply to the `name`
--- @param excludes string[] List of 0 or more regex to apply to name and path
local function matcher(name, path, matches, excludes)
  local name_matches = false
  local name_excluded = false
  local path_excluded = false

  for _, match in ipairs(matches) do
    if name:match(match) then
      Logger:trace("'%s' matches '%s'", name, match)
      name_matches = true
      break
    end
  end

  for _, exclude in ipairs(excludes) do
    if name:match(exclude) then
      Logger:trace("'%s' excluded by '%s'", name, exclude)
      name_excluded = true
      break
    end
    if path:match(exclude) then
      Logger:trace("'%s' excluded by '%s'", path, exclude)
      path_excluded = true
      break
    end
  end

  if name_matches then
    if name_excluded or path_excluded then
			Logger:trace('%s is not a match', name)
      return false
    else
			Logger:trace('%s is a match', name)
      return true
    end
  else
			Logger:trace('%s is not a match', name)
    return false
  end
end


---@alias findType string
---| '"file"' # Find files
---| '"directory"' # Find directories
---| '"link"' # Find links
---| '"socket"' # Find sockets
---| '"char"' # Find characters
---| '"block"' # Find blocks
---| '"fifo"' # Find fifo queues

---@class FinderOptions
---@field dir? string The root to start the find operation in. If omitted, use
--- the caller's directory as the root.
---@field matches? string A list of patterns to apply to object names for inclusion. If
--- ommited, use `{'(.+).lua$'}`
---@field excludes? table A list of object names to exclude.
---@field type? findType The type of object to find.  If ommited, use `'file'`
---@field limit? number The upper limit of objects to find.  If ommitted use
--- `math.huge`

---@public
---@param params FinderOptions Options used to find objects
---@return table|nil Return a list of found objects or nil
function FileSystem.find(params)
  local directory, matches, excludes, files, limit, type

  if is.a_string(params) then
    directory = params
  elseif is.a_array(params) then
    directory = params[1] or nil
    matches   = params[2] or nil
    excludes  = params[3] or nil
    type      = params[4] or nil
    limit     = params[5] or nil
  elseif is.a_dictionary(params) then
    directory = params.dir or nil
    matches   = params.matches or nil
    excludes  = params.excludes or nil
    type      = params.type or nil
    limit     = params.limit or nil
  end


  -- Handle any empty params ------------------------------------------------
  -- 1. directory -----------------------------------------------------------
  -- use the callers directory if not given
  if is.empty(directory) then
    Logger:trace("No starting directory given. Using caller's directory")
    local info = debug.getinfo(2, 'S')
    local fullname,_ = info.source:gsub('^@', '')
    directory = FileSystem.parent(fullname)
    local f = FileSystem.filename(fullname)
    local ex = f .. '$'
    Logger:trace("Adding %s as the base directory", directory)

    if is.empty(excludes) then
      excludes = { ex }
      Logger:trace("Adding '%s' as the exclude", table.concat(excludes, ', '))
    end
  end
  -- 2. match --------------------------------------------------------------
  if is.empty(matches) then matches = { "(.+).lua$" } end
  -- 3. exclude ------------------------------------------------------------
  if is.empty(excludes) then excludes = {} end
  -- 4. details ------------------------------------------------------------
  -- 4.a limit
  if is.empty(limit) then limit = math.huge end

  -- 4.b type
  if is.empty(type) then type = 'file' end

  -- -----------------------------------------------------------------------
  -- finally: call vim.fs.find

  Logger:trace("Finding all %ss in '%s' that match '%s' except '%s'",
    type, directory, table.concat(matches, ', '), table.concat(excludes, ', '))

  files = NeovimFs.find(
    function(name, path)
			Logger:trace('- Checking %s in %s', name, path)
      local result = matcher(name, path, matches, excludes)
      Logger:trace('Result: %s', result)
      return result
		end,
    { type = type, limit = limit, path = directory })

  if #files == 0 then
    Logger:trace("No files found")
  else
    Logger:trace("- found %s", table.concat(files, ", "))
  end

  return files
end


return FileSystem
