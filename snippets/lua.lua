
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local ai = require('luasnip.nodes.absolute_indexer')
local events = require('luasnip.util.events')
local extras = require('luasnip.extras')
local opt = require('luasnip.nodes.optional_arg')
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require('luasnip.extras.expand_conditions')
local postfix = require('luasnip.extras.postfix').postfix
local types = require('luasnip.util.types')
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key

local M = {
  s(
    { name = 'middleclass', trig = ',class', snippetType = 'autosnippet', desc = 'OO module' },
    fmta(
      [[
      local class = require('extern.middleclass')

      local <> = class('<>')


      function <>:initialize()
        <>
      end

      return <>
      ]],
      { i(1, 'Class name'), rep(1), rep(1), i(0), rep(1) }
    )
  ),
  s(
    { name = 'module-as-class', trig = ',mod-class', snippetType = 'autosnippet', desc = 'OO module' },
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
      {
        i(1, 'Module name'), -- local <M>
        rep(1), -- setmt <M>
        rep(1), -- index <M>
        rep(1), -- <M>:new
        rep(1), -- instance setmt <M>
        i(0), -- final <cursor>
        rep(1), -- return <M>
      }
    )
  ),
}

return M
