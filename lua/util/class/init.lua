
local guard = require('util.class.guard')

---@generic T
---@param base T? Optional base class to inherit from
---@return T A new class table with `__call` constructor and optional inheritance
---@diagnostic disable-next-line: lowercase-global
local function class(base)
  local cls = {}
  cls.__index = cls

  setmetatable(cls, {
    __call = function(_, ...)
      local instance = setmetatable({}, cls)
      if cls.init then
        -- Wrap init with guard
        local function safe_init(...)
          guard.assert_instance(instance, cls)
          return cls.init(instance, ...)
        end
        safe_init(...)
      end
      return instance
    end
  })

  if base then
    setmetatable(cls, { __index = base })
    cls.super = base
  end

  return cls
end

return class
