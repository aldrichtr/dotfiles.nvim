
local cmd = vim.api.nvim_create_autocmd -- (event, opts)
local set  = vim.keymap.set -- (mode, lhs, rhs, opts)

local M = {}

function M.setup()
  M.on_save_any()
  M.add_q_to_quit()
end


--- Actions when a file is saved
---@return nil
function M.on_save_any()
  -- Remove trailing whitespace
  cmd({'BufWritePre'},
      {pattern = {'*'},
       desc = 'Remove trailing whitespace on save',
       command = [[%s/\s\+$//e]] })

end

function M.add_q_to_quit()
  local filetypes = { 'help', 'qf', 'netrw' }

  cmd({'FileType'},
      { pattern = table.concat(filetypes, ','),
        desc = 'Close help, quickfix, netrw, etc. windows with q',
        callback = function()
          set('n', 'q', '<C-w>c',
              { buffer = true,
                desc = 'Quit help, quickfix, netrw, etc. windows' })
        end})
end

return M
