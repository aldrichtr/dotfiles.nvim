
local M = {}

function M:setup()
  local wk = require('which-key')

  wk.add({
    {
      { '<leader>v', group = 'View', icon = '󱢉 ' },
      { '<leader>vl', group = 'Logs', icon = '' },
      {
        '<leader>vln',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notifier messages',
      },
      { '<leader>vlm', ':messages', desc = 'Messages buffer' },
    },
  })

end

return M
