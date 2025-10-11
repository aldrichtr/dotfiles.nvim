--[[ A utility module for loading other modules ]]--
local path = require('util.path')
local is = require('util.is')

local load = {}

--- Require all files in the given path.
--- If arguments are provided, they will be passed to each module as a function call.
---@param find string Path to the directory to look for files in.
---@param ... any Optional arguments to pass to each module.
---@return table modules Table of required modules.
function load.all(find, ...)
  if find == "" then
    error("❌ 'find' must not be empty")
  end
  local options = ...
  local files = path.find(find)

  local results = {}
  local result
  for _, file in ipairs(files) do
    local mod = path.convert_to_module(file)
    log.trace("loading module", mod)
    if is.present(options) then
      result = require(mod)(options)
    else
      result = require(mod)
    end
    table.insert(results,result)
  end
  return results
end

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
