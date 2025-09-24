local M = {
  'hiphish/rainbow-delimiters.nvim',
}

M.event = 'BufReadPre'

M.config = function()

  local rb = require('rainbow-delimiters')

  local options = {
    strategy = {
      [''] = rb.strategy['global'],
      commonlisp = rb.strategy['local'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      latex = 'rainbow-blocks',
    },
    highlight = {
      'RainbowDelimiterCyan',
      'RainbowDelimiterBlue',
      'RainbowDelimiterYellow',
      'RainbowDelimiterGreen',
      'RainbowDelimiterRed',
      'RainbowDelimiterViolet',
      'RainbowDelimiterOrange',
    },
    blacklist = {},
  }

  require('rainbow-delimiters.setup').setup(options)
end

return M
