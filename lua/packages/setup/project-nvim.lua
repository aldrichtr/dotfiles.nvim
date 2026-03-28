---@class LazyPluginSpec
M = {
  "DrKJeff16/project.nvim",
}

M.dependencies = {
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  "wsdjeg/picker.nvim",
  "folke/snacks.nvim",
  "ibhagwan/fzf-lua",
}

M.cmd = {
  "Project",
  "ProjectAdd",
  "ProjectConfig",
  "ProjectDelete",
  "ProjectExport",
  "ProjectFzf", -- If using `fzf-lua` integration
  "ProjectHealth",
  "ProjectHistory",
  "ProjectImport",
  "ProjectLog", -- If logging is enabled
  "ProjectPicker", -- If using `picker.nvim` integration
  "ProjectRecents",
  "ProjectRoot",
  "ProjectSession",
  "ProjectSnacks", -- If using `snacks.nvim` integration
  "ProjectTelescope", -- If using `telescope.nvim` integration
}


M.opts = {}


return M
