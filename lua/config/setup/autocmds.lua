
local M = {}

setmetatable(M, {
  __index = M,
  __call = function(_, ...) return M:init(...) end 
})

function M:init(opts)
  local create = vim.api.nvim_create_autocmd
  local cmds = {
    {
      { 'BufWritePre' },
      { pattern = { '*' }, desc = 'Remove trailing whitespace on save', command = [[%s/\s\+$//e]] },
    },
    {
      { 'ModeChanged' },
      {
        pattern = { 'n:i', 'v:s' },
        desc = 'Disable diagnostics in insert and select mode',
        callback = function() vim.diagnostic.config({ virtual_text = false }) end,
      },
    },

    {
      { 'ModeChanged' },
      {
        pattern = 'i:n',
        desc = 'Enable diagnostics when leaving insert mode',
        callback = function(e) vim.diagnostic.config({ virtual_text = true }) end,
      },
    },

    {
      { 'FileType' },
      {
        desc = 'Close help, quickfix, netrw, etc. windows with q',
        pattern = 'help,qf,netrw',
        callback = function()
          vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, desc = 'Quit help, quickfix, netrw, etc. windows' })
        end,
      },
    },
  }

  for _, cmd in pairs(cmds) do
    create(cmd[1], cmd[2])
  end
end

return M
