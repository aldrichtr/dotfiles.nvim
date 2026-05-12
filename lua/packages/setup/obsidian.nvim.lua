
M = {
  "epwalsh/obsidian.nvim"
}

M.dependencies = {
  "nvim-lua/plenary.nvim"
}
M.version = "*"

M.lazy = true

M.ft = "markdown"


M.opts = {
  workspaces = {
    {
      name = 'KmSystem',
      path = "t:/vaults/KmSystem"
    }
  },
  notes_subdir = "notes",
  new_notes_location = "notes_subdir",
  daily_notes = {
    folder = "journal",
    date_format = "%Y.%m.%d"
  }
}


return M
