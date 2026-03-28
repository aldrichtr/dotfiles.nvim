
local M = {}

setmetatable(M, {
  __index = M,
  __call = function(_, ...) return M:init(...) end
})

function M:init(opts)
  local create = vim.api.nvim_create_autocmd
  local buf    = vim.lsp.buf
  local diag   = vim.lsp.diagnostic
  --
  -- #region Create an autocmd for when the LSP is started
  local cmds = {
    {{"LspAttach"} ,
    {desc = "LSP actions",
    callback = function()
      local bufmap = function(mode, lhs, rhs, opts)
        opts["buffer"] = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end
      bufmap("n", "gK", function() buf.hover() end, { desc = "Displays hover information about the symbol under the cursor" })
      bufmap("n", "gd", function() buf.definition() end, { desc = "Jump to the definition" })
      bufmap("n", "gD", function() buf.declaration() end, { desc = "Jump to declaration" })
      bufmap("n", "gi", function() buf.implementation() end, { desc = "Lists all the implementations for the symbol under the cursor" })
      bufmap("n", "go", function() buf.type_definition() end, { desc = "Jumps to the definition of the type symbol" })
      bufmap("n", "gr", function() buf.references() end, { desc = "Lists all the references" })
      bufmap("n", "gs", function() buf.signature_help() end, { desc = "Displays a functions signature information" })
      bufmap("n", "<F2>", function() buf.rename() end, { desc = "Renames all references to the symbol under the cursor" })
      bufmap("n", "<F4>", function() buf.code_action() end, { desc = "Selects a code action available at the current cursor position" })
      bufmap("n", "gl", function() diag.open_float() end, { desc = "Show diagnostics in a floating window" })
      bufmap("n", "[d", function() diag.goto_prev() end, { desc = "Move to the previous diagnostic" })
      bufmap("n", "]d", function() diag.goto_next() end, { desc = "Move to the next diagnostic" })
    end,
  }},
  {{'BufWritePre' },
  {pattern = { '*' }, desc = 'Remove trailing whitespace on save', command = [[%s/\s\+$//e]] }, },
  {{'ModeChanged' },
  {pattern = { 'n:i', 'v:s' },
  desc = 'Disable diagnostics in insert and select mode',
  callback = function() vim.diagnostic.config({ virtual_text = false }) end, }, },
  {{'ModeChanged' },
  {pattern = 'i:n',
  desc = 'Enable diagnostics when leaving insert mode',
  callback = function(e) vim.diagnostic.config({ virtual_text = true }) end, }, },
  {{'FileType' },
  {desc = 'Close help, quickfix, netrw, etc. windows with q',
  pattern = 'help,qf,netrw',
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, desc = 'Quit help, quickfix, netrw, etc. windows' })
  end}}
}

for _, cmd in pairs(cmds) do
  create(cmd[1], cmd[2])
end
end

return M
