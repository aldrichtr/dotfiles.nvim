
local is = require('util.is')

local function normalize(path)
	local result
	result = vim.fs.normalize(path)
	return vim.fs.abspath(result)
end


-- This module does too much.  Maybe it should be a Path object, built during
-- initialization, with the functions for doing things to paths, but right now
-- it is two things:
-- A set of functions that do path calculations, a valid util module, but it is
-- also a big ball of paths to significant configuration directories.

local Path = {}

-- Convenience alias to joinpath
Path.join = vim.fs.joinpath

-- -------------------------------------------------------------------------------------
-- #region Locations
-- This is neovim's configuration directory, where init.lua lives
-- $env:XDG_USER_CONFIG_DIR/nvim
Path.init = normalize(vim.fn.stdpath('config'))

-- This is neovim's local directory, where packages, tools, and libraries are stored
-- $env:XDG_USER_DATA_DIR/nvim-data
Path.data = normalize(vim.fn.stdpath('data'))

-- Environmental paths (windows though)
Path.LocalAppData = normalize(vim.env.LOCALAPPDATA)
Path.AppData = normalize(vim.env.APPDATA)
Path.Home = vim.env.HOME
Path.Programs = normalize('c:/programs')

Path.dotfiles = Path.join(Path.Home, '.dotfiles')

Path.lua = Path.join(Path.init, 'lua')
-- TODO: This might be confusing because it seems like stdpath('config') should be `config`
--       but it is the path to the main config of my init `lua/config`
Path.config = Path.join(Path.lua, 'config')

Path.lsp = { root = Path.join(vim.env.LOCALAPPDATA, 'lsp'),
logs = Path.join(Path.data, 'logs') }

Path.lsp['lua'] = Path.join(Path.lsp.root, 'lua')
Path.lsp['pses'] = Path.join(Path.lsp.root, 'pwsh')

-- #endregion Locations
-- -------------------------------------------------------------------------------------

---@param p string potential path to a directory or file
---@return boolean true if the directory or file is present on the system
function Path.exists(p)
	if vim.uv.fs_stat(p) then
		return true
	else
		return false
	end
end

--- Convert a file path to a module specific, such as:
--- ~/.config/nvim/lua/config/foo.lua => 'config.foo'
---@param file string fully-qualified path to a lua file
---@return string "dot-separated" path to file
function Path.convert_to_module(file)
	local filename, relpath, modpath
	local root = normalize(Path.lua)
	log.trace("converting file '" .. file .. "' to module")
	filename = normalize(file)

	if vim.fs.basename(filename):match("^init") then
		filename = vim.fs.dirname(filename)
	else
		filename = filename:gsub("%.lua", "")
	end
	log.trace("Getting relative path for '" .. filename .. "' from '" .. root .. "'")
	relpath = vim.fs.relpath(root, filename)
	if is.present(relpath) then
		log.trace("Now creating module name from '" .. relpath .. "'")
		modpath = relpath:gsub("/", ".")
		return modpath
	else
		error("attempt to convert non-init path '" .. file .. "'", 1)
	end
end

--- Convert a module specification to a file path, such as:
--- 'config.foo' => ~/.config/nvim/lua/config/foo.lua
function Path.convert_to_path(mod)
	local file = mod:gsub("%.","/")
	file = Path.join(Path.lua, file)
	file = file .. '.lua'
	return Path.join(Path.lua, file)
end


---@param count integer  the number of callers back from the
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

---@param dir string The root directory to find files in
---@param match string A pattern to apply to file names for inclusion
---@param exclude table A list of file names to exclude
---@param details table Details to pass to the vim find cmd. limit and type
function Path.find(...)
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
			log.trace(string.format("Parameter '%s' => '%s'", k, v))
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

	log.trace(string.format("Finding files in '%s' that match '%s'", details.path, match))
	files = vim.fs.find(
		function(name, path) 
			return name:match(match) and not exclude[name]
		end , details)

	log.trace("- found " .. table.concat(files, ", "))
	return files
end


return Path

