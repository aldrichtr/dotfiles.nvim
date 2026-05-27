-- Abbreviations provided when loaded by luasnip
local ls = require('luasnip')
local s  = ls.snippet


M = {
  s({ trig = ",section", snippetType="autosnippet", desc = "Section comment markers"},
    fmta(
      [[
      SECTION <>
      <>
      !SECTION <>
      ]],
      { i(1), i(2), rep(1)}
    )
  ),

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
