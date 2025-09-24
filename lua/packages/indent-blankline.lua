
local M = {
  'lukas-reineke/indent-blankline.nvim'
}

-- The name of the module is 'ibl'. `main` tells lazy.nvim to load the ibl
-- module, vice `indent-blankline`
M.main = 'ibl'

M.event = 'BufReadPre'

M.config = function()

  local highlight = {
    'RainbowOrange',
    'RainbowCyan',
    'RainbowBlue',
    'RainbowYellow',
    'RainbowGreen',
    'RainbowRed',
    'RainbowViolet'
  }
  local hooks = require('ibl.hooks')
  local hilight = vim.api.nvim_set_hl

  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    hilight(0, 'RainbowOrange', { fg = "#d49158" })
    hilight(0, 'RainbowCyan', { fg = "#16fad8" })
    hilight(0, 'RainbowBlue', { fg = "#41a7fa" })
    hilight(0, 'RainbowYellow', { fg = "#bfb133" })
    hilight(0, 'RainbowGreen', { fg = "#116f6e" })
    hilight(0, 'RainbowRed', { fg = "#fd70b2" })
    hilight(0, 'RainbowViolet', { fg = "#b084eb" })
    end)
    require('ibl').setup( { scope = { highlight = highlight } })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

end

return M
