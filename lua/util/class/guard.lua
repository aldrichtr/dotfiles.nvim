
local guard = {}

--- Ensures init() is called on an instance, not the class table
---@param self table
---@param class table
function guard.assert_instance(self, class)
  if self == class then
    error("init() called on class table instead of instance. Use Class(...) to instantiate.")
  end
end

-- TODO: guard.assert_metadata(self, 'tag')
-- TODO: guard.assert_mixin(self, 'Logger')
return guard
