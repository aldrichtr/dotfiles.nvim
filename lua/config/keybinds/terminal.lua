
local M = {}

function M:setup()
  local wk = require('which-key')

  wk.add({
    {
      mode = { 'n' },
      { '<leader>>', group = 'Terminal & Shell' },
      { '<leader>>p', group = 'PowerShell' },
      {
        '<leader>>pi',
        function()
          require('powershell').toggle_term()
        end,
        { desc = 'Integrated Terminal' },
      },
      {
        '<leader>>pd',
        function()
          require('powershell').toggle_debug_term()
        end,
        { desc = 'Debug Terminal' },
      },
    },
  })
end

return M
