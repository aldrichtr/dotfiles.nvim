-- Util module

local M = {}

---Attempt to load ('require') a module with error handling
---@param mod string dot-separated path to module
---@return any
function M.try(mod)
  local ok, mod_or_err = pcall(require, mod)
  if not ok then
    vim.notify('Error loading module ' .. mod .. "': " .. mod_or_err)
  end
  return mod_or_err
end

---```lua
--- local dayTime = 11
---
--- switch(dayTime) {
---   [11] = function() print("It's morning.") end,
---   [18] = function() print("It's afternoon.") end,
---   default = function() print("Unknown time.") end
--- }
---```
---A switch/case statement for lua
---@param value any
---@return function
function M.switch(value)
  return function(cases)
    local case = cases[value] or cases.default
    if case then
      return case(value)
    else
      error(string.format("Unhandled case (%s)", value), 2)
    end
  end
end

--- Toggle line numbers between relative and ordered
function M.toggle_numbers()
  if vim.o.relativenumber then
    vim.opt.relativenumber = false
  else
    vim.opt.relativenumber = true
  end
end


-- filter files based on extension and options
--- @retur
function should_import(opts)
  local ext = opts.extension or 'lua'
	ext = ext .. '$'
  local fbase = vim.fs.basename(opts.path)
  local fext  = vim.fn.fnamemodify(opts.path, ':e')
	-- Start out expecting the file to match
	local is_matched = true
	if not string.match(fext, ext) then
		is_matched = false
	else
		for _, pattern in ipairs(opts.exclude) do 
			if fbase:match(pattern) then
				is_matched = false
				break
			end
		end
	end
	return is_matched
end


---Require all of the lua modules in the given path
---@param path string The path to require modules from
---@param exclude? table<string> Array of patterns to exclude
---@param depth? How many levels to recurse
---@param options? table Table of options passed to the required file
---@return nil|string nil on success, message on error
function M.require_all(opts)
end

function M.path_exists(path)
  return vim.loop.fs_stat(path) ~= nil
end

return M