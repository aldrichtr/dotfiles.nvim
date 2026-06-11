
local is = require("util.is")

-- SECTION Meta information

---@alias Scope string
---| '""' # unknown / empty
---| '"upvalue"'
---| '"field"'
---| '"method"'
---| '"local"'
---| '"global"'

---@alias LangType string
---| '""' # unknown / empty
---| '"lua"'
---| '"c"'

---@class ExtentInfo
---@field text string The content
---@field call string The line in the content that made the call
---@field start_line number Line number where the function or method is defined
---@field end_line number Line number where the function or method ends
---@field current_line number Line number where the call was made

---@class LocationInfo
---@field path? string The path to the file of the caller
---@field source? string If the caller is not defined in a file, the source is
--- the string of its definition
---@field start number The line number where the function starts
---@field line number The current line number that called
---@field close number The line number where the function ends

---@class Caller
---@field scope Scope
---@field type LangType
---@field name string The name of the caller
---@field file LocationInfo File and line information of the caller

-- !SECTION

-- SECTION Initialization
local Caller = {
  scope = "",
  stack_index = 0,
  name = "",
  type = "",
  path = "",
  extent = {
    text         = "",
    call         = "",
    start_line   = 0,
    current_line = 0,
    end_line     = 0,
  },
}

setmetatable(Caller, {
  __index = Caller,
  __call = function(cls, ...)
    return cls.new(cls, ...)
  end,
})

local debug_options = {
  'n', -- name
  'S', -- source, short_src, linedefined, lastlinedefined
  'l', -- currentline,
  'u', -- nups
  'f', -- function
  'L', -- table of numbers of lines that are valid on a function
}

---@public
---@param count integer  the number of callers back from the
--- caller of this function.  0 or nil is the calling function,
--- 1 would be the caller of the caller, etc.
---@return Caller
function Caller:new(count)
  local jumps = 2 -- 1 == this function, 2 == the function that calls Caller:new
  if is.a_number(count) then jumps = jumps + count end

  local remote = debug.getinfo(jumps, "nSlufL")

  return self
end
-- !SECTION

---@private
---@param
local function getExtent()
  if is.filled(self.source) then
    self.extent.text = self.source
    return self.source
  end
  if is.filled(self.path) then
    self.extent.text = {}
    local f = io.open(self.path, "r")
    assert(f ~= nil, string.format("Error, could not read file '%s'", self.path))
    local l = 0
    local collect = {}
    for line in f:lines() do
      l = l + 1
      if l >= self.extent.start then
        if l == self.extent.line then
          line = string.format(">%s", line)
        end
        table.insert(collect, line)
      end
    end
    self.extent.text =
  end
end

---@public
---@param s? string The source of the caller.  Use `self.source` by default
---@return boolean
function Caller:is_file(s)
  local source = s or self.source
  if is.a_string(source) then
    local first = source:sub(1, 1)
    return first == "@"
  end
  return false
end
