
local function telescope()
  local telescope = require('telescope.builtin')

  local keys = {
    {'<leader>ff', telescope.find_files, desc = "Telescope find files" },
    {'<leader>/', telescope.grep_string, desc = "Telescope grep thing under point"}

  }
  return keys
end


return telescope
