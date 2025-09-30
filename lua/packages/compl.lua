
local M = {
  "brianaung/compl.nvim",
}

M.opts = {
    -- Default options (no need to set them again)
    completion = {
      fuzzy = false,
      timeout = 100,
    },
    info = {
      enable = true,
      timeout = 100,
    },
    snippet = {
      enable = false,
      paths = { }
  },
}

return M