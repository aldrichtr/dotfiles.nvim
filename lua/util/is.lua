
--- Semantic type-checking and value introspection helpers.
--- Designed for expressive, readable validation in Lua.
--- Usage:
---```lua
--- local is = require('util.is')
--- if is.string(name) and is.filled(name) then ...
--- if is.table(config) and is.present(config) then ...
--- if is.falsey(flag) then ...
--- if is.one_of(mode, { "light", "dark" }) then ...
--- if is.match(email, "^.+@.+%..+$") then ...
---```

local is = {}

-- Core type checks

--- Check if value is nil.
---@param v any
---@return boolean
function is.nul(v) return v == nil end

--- Check if value is a boolean.
---@param v any
---@return boolean
function is.a_boolean(v) return type(v) == "boolean" end

--- Check if value is a number.
---@param v any
---@return boolean
function is.a_number(v) return type(v) == "number" end

--- Check if value is a string.
---@param v any
---@return boolean
function is.a_string(v) return type(v) == "string" end

--- Check if value is a function.
---@param v any
---@return boolean
function is.a_function(v) return type(v) == "function" end

--- Check if value is a table.
---@param v any
---@return boolean
function is.a_table(v) return type(v) == "table" end

--- Check if value is userdata.
---@param v any
---@return boolean
function is.a_userdata(v) return type(v) == "userdata" end

--- Check if value is a thread (coroutine).
---@param v any
---@return boolean
function is.a_thread(v) return type(v) == "thread" end

-- Structural helpers

--- Check if value is an empty string or empty table.
---@param v any
---@return boolean
function is.empty(v)
  if is.a_string(v) then return v == "" end
  if is.a_table(v) then return next(v) == nil end
  return false
end

--- Check if value is a non-empty string or table.
---@param v any
---@return boolean
function is.filled(v)
  if is.a_string(v) then return v ~= "" end
  if is.a_table(v) then return next(v) ~= nil end
  return false
end

--- Check if value is present (not nil and not empty).
---@param v any
---@return boolean
function is.present(v)
  return v ~= nil and not is.empty(v)
end

--- Check if string is blank (nil, empty, or only whitespace).
---@param v any
---@return boolean
function is.blank(v)
  return is.a_string(v) and v:match("^%s*$") ~= nil
end

-- Truthiness helpers

--- Check if value is truthy (not nil and not false).
---@param v any
---@return boolean
function is.truthy(v)
  return v ~= nil and v ~= false
end

--- Check if value is falsey (nil or false).
---@param v any
---@return boolean
function is.falsey(v)
  return v == nil or v == false
end

-- Value matchers

--- Check if value is one of the allowed options.
---@param v any
---@param list table List of allowed values.
---@return boolean
function is.one_of(v, list)
  if not is.a_table(list) then return false end
  for _, item in ipairs(list) do
    if v == item then return true end
  end
  return false
end

--- Check if string matches a Lua pattern.
---@param v any
---@param pattern string Lua pattern to match against.
---@return boolean
function is.match(v, pattern)
  return is.a_string(v) and is.a_string(pattern) and v:match(pattern) ~= nil
end

return is
