
local function neotree_keys()
  local keys = {
    -- Toggle neotree filesystem
    { '<leader>0', '<cmd>Neotree<cr>', desc = 'Reveal the file explorer'},
    -- Version Control
    { '<leader>gs', '<cmd>Neotree float git_status<cr>'}
  }
  return keys

end


return neotree_keys