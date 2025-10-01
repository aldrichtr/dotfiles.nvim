
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
function switch(value)
  return function(cases)
    local case = cases[value] or cases.default
    if case then
      return case(value)
    else
      error(string.format("Unhandled case (%s)", value), 2)
    end
  end
end

return switch
