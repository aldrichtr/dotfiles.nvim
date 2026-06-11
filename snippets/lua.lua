
local ls = require('luasnip')

local M = {
  s({ name = 'module-as-class',
      trig = ',mod-class',
      snippetType = 'autosnippet',
      desc = 'OO module'
    },
    fmta(
      [[
      local <> = {}
      setmetatable( <>, {
        __index = <>,
        __call  = function(cls, ...) return cls.new(cls, ...) end,
      })

      function <>:new()
        local instance = setmetatable({}, <>)
        <>
        return instance
      end

      return <>
      ]],
      { i(1, "Module name"), -- local <M>
        rep(1),              -- setmt <M>
        rep(1),              -- index <M>
        rep(1),              -- <M>:new
        rep(1),              -- instance setmt <M>
        i(0),                -- final <cursor>
        rep(1)               -- return <M>
      }
    ))}

return M
