--[[ A utility module for loading other modules ]]--

local path = require('util.path')
local is = require('util.is')

local load = {}

--- Require all files in the given path.
--- If arguments are provided, they will be passed to each module as a function call.
---@param root string Path to the directory to look for files in.
---@param ... any Optional arguments to pass to each module.
---@return table modules Table of required modules.
function load.all(root, ...)
  if is.empty(root) then
    error("❌ 'root' must not be empty")
  end
  log.trace(string.format("Loading all lua files in '%s'", root))
  local options = ...

  local files = path.find({
    dir = root,
    match = "(.+).lua$",
    exclude = {"init.lua"}})

  local results = {}
  local result
  for _, file in ipairs(files) do
    local mod = path.convert_to_module(file)
    log.trace("loading module", mod)
    if is.present(options) then
      result = require(mod){options}
    else
      result = require(mod)
    end
    table.insert(results,result)
  end
  return results
end
---
--- Attempt to require a module with error handling.
---
--- ## Usage
--- ### 1. Simple require
--- ```lua
--- local mod, err = load.try("my.module")
--- if not mod then
---   log.error("Failed to load module: " .. err)
--- end
--- ```
---
--- ### 2. Require a module *that returns a function*, and call it
--- ```lua
--- local result, err = load.try("my.module.init", "arg1", "arg2")
--- if not result then
---   log.warn("Module init failed: " .. err)
--- end
--- ```
---
--- ### 3. Use as a safe optional dependency
--- ```lua
--- local telescope = load.try("telescope")
--- if telescope then
---   telescope.setup({})
--- end
--- ```
---
--- ### 4. Use inside plugin setup blocks
--- ```lua
--- local ok, colorscheme = load.try("colors.mytheme")
--- if ok then
---   vim.cmd("colorscheme mytheme")
--- end
--- ```
---
--- Returns:
---   - result: module or function return value, or nil on failure
---   - err: error message if failure occurred
--- Attempt to require a module with error handling.
--- If arguments are provided, they will be passed to the module as a function call.
---@param mod string Dot-separated path to module.
---@param ... any Optional arguments to pass to the module.
---@return any|nil result The required module or nil on failure.
---@return string|nil err Error message if failure occurred.
function load.try(mod, ...)
  local args = {...}
  log.trace("🔍 pcall to require " .. mod .. (#args == 0 and " with no options" or " with options"))

  local success, result
  if #args == 0 then
    success, result = pcall(require, mod)
  else
    success, result = pcall(function() return require(mod)(table.unpack(args)) end)
  end

  if success then
    log.trace("✅ pcall was successful")
    return result
  else
    log.trace("❌ pcall failed: " .. tostring(result))
    return nil, result
  end
end

--- Attempt to require a module with error handling and a custom handler.
--- If arguments are provided, they will be passed to the module as a function call.
---@param mod string Dot-separated path to module.
---@param handler fun(err: string): any Custom error handler function.
---@param ... any Optional arguments to pass to the module.
---@return any|nil result The required module or nil on failure.
function load.xtry(mod, handler, ...)
  if type(handler) ~= "function" then
    error("❌ load.xtry: Expected a function as the second parameter")
  end

  local args = {...}
  log.trace("🔍 xpcall to require " .. mod .. (#args == 0 and " with no options" or " with options"))

  local called
  if #args == 0 then
    called = function() return require(mod) end
  else
    called = function() return require(mod)(table.unpack(args)) end
  end

  local success, result = xpcall(called, handler)

  if success then
    log.trace("✅ xpcall was successful")
    return result
  else
    log.trace("❌ xpcall failed: " .. tostring(result))
    return nil, result
  end
end

--- Attempt to require a module with a default error handler.
--- Logs the error and returns nil on failure.
---@param mod string Dot-separated path to module.
---@param ... any Optional arguments to pass to the module.
---@return any|nil result The required module or nil on failure.
function load.safe(mod, ...)
  return load.xtry(mod, function(err)
    log.error("❌ load.safe: Failed to load " .. mod .. ": " .. tostring(err))
    return nil
  end, ...)
end

return load
