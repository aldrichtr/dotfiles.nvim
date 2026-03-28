
local function telescope()
  local builtin = require('telescope.builtin')

  local keys = {
    {'<leader>ff', builtin.find_files, desc = "Telescope find files" },
    {'<leader>/', builtin.grep_string, desc = "Telescope grep thing under point"}

  }
  return keys
end


return telescope