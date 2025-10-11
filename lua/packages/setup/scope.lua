-- Using scope with barbar allows the ability to show only the buffers in the current tab
local M = {
  'tiagovla/scope.nvim',
}

M.lazy = false

M.opts = function(plugin, opts)
  require("telescope").load_extension("scope")
    opts.hooks = {
      pre_tab_leave = function() vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' }) end,

      post_tab_enter = function() vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' }) end
    }
end

return M