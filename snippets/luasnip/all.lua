-- Abbreviations provided when loaded by luasnip
-- local ls = require("luasnip")
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local rep = require("luasnip.extras").rep
--
-- Anatomy of a LuaSnip snippet
-- require("luasnip").snippet(
  -- context:table,   -- context table of snippet parameters
  -- nodes:table,     -- table of snippet nodes
  -- opts:table|nil   -- *optional* table of additional snippet options
-- )
local M = {
  s({ trig = ",region", snippetType="autosnippet", desc = "Region comment markers"},
    fmta(
      [[
      #region <>
      <>
      #endregion <>
      ]],
      { i(1), i(2), rep(1)}
    )
  )
}



return M