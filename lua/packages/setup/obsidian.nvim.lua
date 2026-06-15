M = {
  'epwalsh/obsidian.nvim'
}

M.version = '*'

M.lazy = true

M.event = {
  "BufReadPre t:/vaults/KmSystem/*.md",
  "BufNewFile t:/vaults/KmSystem/*.md",
}

M.dependencies = {
  'nvim-lua/plenary.nvim'
}

M.opts = {
  workspaces = {
    { name = 'KmSystem', path = 't:/vaults/KmSystem/' }
  },
  daily_notes = {
    folder = 'journal',
    date_format = '%Y.%m.%d',
  },
  preferred_link_style = 'wiki',

}

return M
